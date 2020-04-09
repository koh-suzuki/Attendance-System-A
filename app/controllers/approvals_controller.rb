class ApprovalsController < ApplicationController
  before_action :set_user, only: [:create, :edit]
  before_action :logged_in_user, only: [:create, :edit, :update, :approval_invalid?]

  
  def create
    if params[:approval][:name].present?
      @approval_create = @user.approvals.build(superior_id: params[:approval][:name], month_at: params[:format])
      @approval_create.save
      flash[:success] = "1ヶ月分の勤怠申請をしました。"
      redirect_to user_path(@user)
    else
      flash[:danger] = "所属長を選択してください。"
      redirect_to user_path(@user)
    end
  end
  
  def edit
    @users = User.where(id: Approval.where(superior_id: @user.id).where(approval_flag: false).where.not(month_at: nil).select(:user_id)).where.not(id: current_user)
    @users.each do |user| 
      @approvals = Approval.where(superior_id: @user.id).where.not(month_at: nil)
      @approvals.each do |approval|
        @ap = approval
      end
    end
  end
  
  def approval_invalid?
    items = []
    approval_params.each do |id, item|
      items << item[:approval_flag]
    end
    if items.all?{|i| i == "false"}
      return false
    else
      return true
    end
  end
  
  def update
    @user = User.find(params[:user_id])
    if approval_invalid?
      approval_params.each do |id, item|
      approval = Approval.find(id)
        if params[:approval][:updated_approvals][id][:approval_flag] == "true"
          approval.update_attributes(item)
        end
      end
      flash[:success] = "1ヶ月分勤怠申請を変更しました"
      redirect_to @user
    else
      flash[:danger] = "変更にチェックがありません。"
      redirect_to @user
    end
  end
  
  
  
  private
    def approval_format_params
      params.permit(:format)
    end
    def approval_name_params
      params.require(:approval).permit(:name)
    end
  
    def approval_params
      params.require(:approval).permit(updated_approvals:[:confirm, :approval_flag])[:updated_approvals]
    end
end
