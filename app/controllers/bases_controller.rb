class BasesController < ApplicationController
  before_action :set_base, only: [:update, :show, :destroy]
  before_action :logged_in_user, only: [:index, :update, :show, :destroy]
  before_action :admin_user, only: [:index, :update, :show, :destroy]

  def index
    @bases = Base.all.order('id ASC')
    @base = Base.new
  end
  
  def new
    @base = Base.new
  end
    
  def create
    @base = Base.new(base_params)
    if @base.save
      flash[:success] = "拠点情報を作成しました。"
      redirect_to bases_url
    else
      flash[:danger] = "拠点情報の作成に失敗しました。"
      @bases = Base.all.order('id ASC')
      render :index
    end
  end
  
  def show
  end
  
  def update
    if @base.update_attributes(base_params)
      flash[:success] = "拠点情報を更新しました。"
      redirect_to bases_url
    else
      flash[:danger] = "更新に失敗しました。"
      render :index
    end
  end
  
  def destroy
    @base.destroy
    flash[:success] = "#{@base.base_name}を削除しました"
    redirect_to bases_url
  end
  
  private
    def set_base
      @base = Base.find(params[:id])
    end
    
    def base_params
      params.require(:base).permit(:base_number, :base_name, :base_attendance)
    end
end
