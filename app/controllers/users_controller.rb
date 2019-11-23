class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :edit_basic_info, :update_basic_info]
  before_action :logged_in_user, only: [:index, :show, :edit, :update, :destroy, :edit_basic_info, :update_basic_info]
  before_action :correct_user, only: [:edit, :update, :edit_basic_info]
  before_action :admin_user, only: [:index, :destroy, :edit_basic_info, :update_basic_info]
  before_action :set_one_month, only: :show
  before_action :admin_or_correct_user, only: :show

  def index
    @users = User.all
  end
 
  def import
    unless params[:file].blank?
      # 保存と結果のメッセージを取得して表示
      User.import(params[:file])
      flash[:info] = "CSVファイルをインポートしました。"
    else
      flash[:danger] = "読み込むCSVファイルをセットしてください"
    end
      redirect_to users_path
  end
  
  def index_attendance
  end
 
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = '新規作成に成功しました。'
      redirect_to @user
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "ユーザー情報を更新しました。"
      redirect_to @user
    else
      render :edit      
    end
  end
  
  def destroy
    @user.destroy
    flash[:success] = "User deleted.."
    redirect_to users_url
  end

  def show
    @worked_sum = @attendances.where.not(started_at: nil).count
  end
  
  def edit_basic_info
  end
  
  def update_basic_info
    if @user.update_attributes(basic_params)
      flash[:success] = "#{@user.name}の基本情報を更新しました。"
    else
      flash[:danger] = "#{@user.name}の更新は失敗しました。<br>" + @user.errors.full_messages.join("<br>")
    end
    redirect_to users_url
  end
  
  def admin_or_correct_user
    unless current_user?(@user) || current_user.admin?
      flash[:danger] = "残念でした！"
      redirect_to(root_url)
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :affiliation, :employee_number, :password)
    end
    
    def basic_params
      params.require(:user).permit(:basic_time, :work_time)
    end
end