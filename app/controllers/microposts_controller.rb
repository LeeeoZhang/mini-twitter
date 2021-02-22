class MicropostsController < ApplicationController

  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user, only: [:destroy]

  def create
    @micropost = current_user.microposts.build(micropost_params)
    @micropost.image.attach micropost_params.image
    if @micropost.save
      flash[:success] = 'Micropost created!'
      redirect_to root_url
    else
      @feed_item = current_user.feed.paginate(page: params[:page]) # 提交失败时也需要一个@feed_item变量来渲染static_page/home
      render 'static_page/home'
    end
  end

  def destroy
    @micropost.destroy
    flash[:success] = 'Micropost deleted!'
    redirect_to request.referer || root_url
  end

  private

    def micropost_params
      params.require(:micropost).permit(:content,:image)
    end

    def correct_user
      @micropost = current_user.microposts.find_by id: params[:id]
      redirect_to root_path if @micropost.nil?
    end

end