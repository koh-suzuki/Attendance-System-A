class AttendancesController < ApplicationController
  include AttendacesHelper
  before_action :set_user, only: [:edit_one_month, :update_one_month, :edit_notice_overtime,
                                  :edit_change_attendance, :update_one_month, :attendance_edit_log]
  before_action :set_attendance, only: [:edit_overtime_app, :update_over_app, :update_notice_overtime]
  before_action :logged_in_user, only: [:update, :edit_one_month]
  before_action :set_one_month, only: [:edit_one_month]
  before_action :admin_or_correct_user, only: [:update, :edit_one_month, :update_one_month]
  before_action :superior_user, only: [:edit_change_attendance]
  
  require 'csv'
  require 'rails/all'
  
  UPDATE_ERROR_MSG = "勤怠登録に失敗しました。やり直してください。"
  
  def update
    @attendance = Attendance.find(params[:id])
    if @attendance.started_at.nil?
      if @attendance.update_attributes(started_at: Time.current.change(sec: 0))
        @attendance.update_attributes(updated_started_at: @attendance.started_at)
        flash[:info] = "おはようございます！"
      else
        flash[:danger] = UPDATE_ERROR_MSG
      end
    elsif @attendance.finished_at.nil? 
      if @attendance.update_attributes(finished_at: Time.current.change(sec: 0))
        @attendance.update_attributes(updated_finished_at: @attendance.finished_at)
        flash[:info] = "お疲れ様でした！"
      else
        flash[:danger] = UPDATE_ERROR_MSG
      end
    end
    redirect_to @user
  end
  
  def csv_output
    @attendance = Attendance.joins(:user).where(id: Attendance.where(user_id: current_user))
    send_data render_to_string, filename: "attendances.csv", type: :csv
  end
  
  def edit_one_month  
  end
  
  def update_one_month
    ActiveRecord::Base.transaction do
      if attendances_updated_invalid?
        updated_time_params.each do |id, item|
          attendance = Attendance.find(id)
          if attendance.name.blank? || present? && item[:name].present?
            attendance.update_attributes!(item)
          else
            flash[:danger] = "支持者を選択してください。"
            redirect_to attendances_edit_one_month_user_url(date: params[:date]) and return
          end
        end
      end
      flash[:success] = "1ヶ月分の勤怠情報を更新しました。"
      redirect_to user_url(date: params[:date])
    end
  rescue ActiveRecord::RecordInvalid
      flash[:danger] = "無効な入力データがあった為、更新をキャンセルしました。"
      redirect_to attendances_edit_one_month_user_url(date: params[:date])
  end

   # 残業申請のモーダル
  def edit_overtime_app
    @attendances = Attendance.where(id: params[:id], user_id: params[:user_id])
    @today = Date.today
  end
  
  # 残業申請の更新処理
  def update_over_app
    @worktime = @user.designated_work_end_time
    @attendance = Attendance.find(params[:id])
    @attendance.update(overtime_params)
    if @attendance.name.blank?
      flash[:danger] = "上長が選択されていません"
      render edit_overtime_app
    else
      flash[:success] = "残業申請しました"
      redirect_to @user
    end
  end
  
  def edit_notice_overtime
    @notice_users = User.where(id: Attendance.where.not(endtime_at: nil).select(:user_id))
    # @notice_users = 「usersテーブルのid」を全て取り出す。
    # 条件：attendancesテーブルの上長名カラム（name）と「ユーザーの名前」が同じ
    #     　全ての勤怠情報からuser_idが重複しないようにセレクトする。
    #       セレクトした「attendancesテーブルのuser_id」が「usersテーブルのid」として
    #       全て取得。
    @attendance_notices = Attendance.where.not(endtime_at: nil)
    @attendance_notices.each do |att_notice|
      @att_notice = att_notice
    end
  end
  
  def update_notice_overtime
    # 前提:form_withのurl引数（@user）はbefore_actionの
    #      set_userによって「上長」のユーザー情報を得る。
    @attendance_notices = Attendance.where.not(endtime_at: nil)
    @attendance_notices.update(overtime_notice_params)
    @attendance_notices.each do |att_notice|
      if att_notice.change == true
        flash[:success] = "残業申請のお知らせを変更しました"
        redirect_to @user and return
      else
        flash[:danger] = "変更にチェックを付けてください"
        redirect_to @user and return
      end
    end
  end
  
  # 勤怠変更申請のお知らせ
  def edit_change_attendance
    @users = User.where(id: Attendance.where.not(updated_started_at: nil).select(:user_id)).where.not(id: current_user)
    @att_update_lists = Attendance.where.not(updated_started_at: nil) || 
                        Attendance.where.not(updated_finished_at: nil)
    @att_update_lists.each do |att_up|
      @att_up = att_up
    end
  end
  
  def update_change_attendance
    
  end
  
  def attendance_edit_log
  end

  
  
  private
    def attendances_params
      params.require(:user).permit(attendances: [:updated_started_at, :updated_finished_at, :started_at, :finished_at, :tommorow_index, :note, :name])[:attendances]
    end
    
    def overtime_params
      params.require(:attendance).permit(:endtime_at, :tommorow_index, :overtime_memo, :name)
    end
    
     def overtime_notice_params
      params.require(:attendance).permit(:confirm, :change)
     end
     
     def updated_time_params
       params.require(:user).permit(attendances: [:updated_started_at, :updated_finished_at, :tommorow_index, :note, :name])[:attendances]
     end
    
    def admin_or_correct_user
      @user = User.find(params[:user_id]) if @user.blank?
      unless current_user?(@user) || current_user.admin?
      flash[:danger] = "編集権限がありません。"
      redirect_to(root_url)
      end
    end
end
