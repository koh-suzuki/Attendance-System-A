class ApprovalsController < ApplicationController
  before_action :set_one_month, only: [:create]

  def create
    @user = User.find(params[:id])
    @superior_users = User.where(superior: true)
    @superior = Approval.create(approval_params)
    flash[:success] = "所属長承認を申請しました。"
    redirect_to @user
  end

    private

    def approval_params
      params.require(:approval).permit(:superior_id)
    end
end
