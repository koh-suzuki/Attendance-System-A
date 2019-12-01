class BasesController < ApplicationController
  def index
    @bases = Base.all
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
      flash[:notice] = "拠点情報の作成に失敗しました。"
      render :index
    end
  end
  
  def show
    @base = Base.find(params[:id])
  end
  
  def update
    @base = Base.find(params[:id])
    if update_attributes(base_params)
      flash[:success] = "拠点情報を更新しました。"
    else
      flash[:danger] = "更新に失敗しました。"
    end
  end
  
  private
    def base_params
      params.require(:base).permit(:base_number, :base_name, :base_attendance)
    end
end
