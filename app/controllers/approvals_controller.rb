class ApprovalsController < ApplicationController

  def create
    @user = User.find(params[:id])
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
  
    private

    def approval_params
      params.require(:approval).permit(:superior_id, :month_at, :approval_flag)
    end
end
