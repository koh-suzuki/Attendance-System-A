class AttendancesController < ApplicationController
  include AttendacesHelper
  before_action :set_user, only: [:edit_one_month, :update_one_month]
  before_action :edit_user_id, only: [:edit_overtime_app, :update_over_app, :edit_notice_overtime, :update_notice_overtime]
  # before_action :set_notice, only: [:edit_notice_overtime]
  before_action :set_attendance_id, only: [:edit_overtime_app, :update_over_app, :edit_notice_overtime,]
  before_action :logged_in_user, only: [:update, :edit_one_month]
  before_action :set_one_month, only: [:edit_one_month, :edit_overtime_app, :edit_notice_overtime, :update_notice_overtime]
  before_action :admin_or_correct_user, only: [:update, :edit_one_month, :update_one_month]
  require 'csv'
  require 'rails/all'
  
  UPDATE_ERROR_MSG = "勤怠登録に失敗しました。やり直してください。"
  
  def update
    @attendance = Attendance.find(params[:id])
    if @attendance.started_at.nil?
      if @attendance.update_attributes(started_at: Time.current.change(sec: 0))
        flash[:info] = "おはようございます！"
      else
        flash[:danger] = UPDATE_ERROR_MSG
      end
    elsif @attendance.finished_at.nil? 
      if @attendance.update_attributes(finished_at: Time.current.change(sec: 0))
        flash[:info] = "お疲れ様でした！"
      else
        flash[:danger] = UPDATE_ERROR_MSG
      end
    end
    redirect_to @user
  end
  
  def csv_output
    @attendance = Attendance.all
    send_data render_to_string, filename: "attendances.csv", type: :csv
  end
  
  def edit_one_month
  end
  
  def update_one_month
    ActiveRecord::Base.transaction do
      if attendances_invalid?
        attendances_params.each do |id, item|
          attendance = Attendance.find(id)
          attendance.update_attributes!(item)
        end
        flash[:success] = "1ヶ月分の勤怠情報を更新しました。"
        redirect_to user_url(date: params[:date])
      else
        flash[:danger] = "無効な入力データがあった為、更新をキャンセルしました。"
        redirect_to attendances_edit_one_month_user_url(date: params[:date])
      end
    end
  rescue ActiveRecord::RecordInvalid
      flash[:danger] = "無効な入力データがあった為、更新をキャンセルしました。"
      redirect_to attendances_edit_one_month_user_url(date: params[:date])
  end
  
   # 残業申請のモーダル
   ## attendance_id は application_controller.rb
  def edit_overtime_app
    @today = Date.today
  end
  
  def update_over_app
    @worktime = @user.designated_work_end_time
    @overtime.update(endtime_at: DateTime.new(
        params[:attendance]["endtime_at(1i)"].to_i,
        params[:attendance]["endtime_at(2i)"].to_i,
        params[:attendance]["endtime_at(3i)"].to_i,
        params[:attendance]["endtime_at(4i)"].to_i,
        params[:attendance]["endtime_at(5i)"].to_i
        ) - 9.hours)
    @overtime.update(overtime_params)
    if @overtime.name.blank?
      flash[:danger] = "上長が選択されていません"
      render edit_overtime_app
    else
      flash[:success] = "残業申請しました"
      redirect_to @user
    end
  end
  
  def edit_notice_overtime
    # @attendance = Attendance.find(params[:id])
    # @at_endtimes = Attendances.where(endtime_at: :endtime_at)
  end
  
  def update_notice_overtime
    # @attendance = Attendance.find(params[:id])
  end
  
  def attendance_edit_log
  end

  
  
  private
    def attendances_params
      params.require(:user).permit(attendances: [:started_at, :finished_at, :tommorow_index, :note, :name])[:attendances]
    end
    
    def overtime_params
      params.require(:attendance).permit(:tommorow_index, :overtime_memo, :name)
    end
    
    def admin_or_correct_user
      @user = User.find(params[:user_id]) if @user.blank?
      unless current_user?(@user) || current_user.admin?
      flash[:danger] = "編集権限がありません。"
      redirect_to(root_url)
      end
    end
end
