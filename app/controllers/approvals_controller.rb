class ApprovalsController < ApplicationController
  # before_action :set_attendance, only: [:edit]
  before_action :set_user, only: [:create, :edit]
  
  def create
    @attendance = @user.attendances.find_by(user_id: @user.id)
    @approval = @user.approvals.build(superior_id: params[:name], month_at: @attendance.worked_on)
    if params[:name].present?
      @approval.save
      flash[:success] = "1ヶ月分の勤怠申請をしました。"
      redirect_to user_path(@user)
    else
      flash[:danger] = "所属長を選択してください。"
      redirect_to user_path(@user)
    end
  end
  
  def edit
    @users = User.where(id: Approval.where(superior_id: @user.id).where.not(month_at: nil).select(:user_id)).where.not(id: current_user)
    @users.each do |user| 
      @approvals = Approval.where(superior_id: @user.id).where(user_id: user.id).where.not(month_at: nil).where(approval_flag: false)
      @approvals.each do |approval|
        @ap = approval
      end
    end
  end
  
  def update
    @user = User.find(params[:user_id])
    approval_params.each do |id, item|
      if params[:approval][:updated_approvals][id][:approval_flag] == "true"
        approval = Approval.find(id)
        approval.update_attributes!(item)
        next
      else
        flash[:danger] = "変更にチェックがありません。"
        redirect_to @user and return
      end
    end
    flash[:success] = "1ヶ月分勤怠申請を変更しました"
    redirect_to @user
  end
  
  private
    def approval_params
      params.require(:approval).permit(updated_approvals:[:confirm, :approval_flag])[:updated_approvals]
    end
end
