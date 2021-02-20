class PasswordResetsController < ApplicationController

  before_action :get_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def new

  end

  def edit

  end

  def create
    @user = User.find_by(email: params[:password_resets][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = 'Email sent with password reset instructions'
      redirect_to root_path
    else
      flash.now[:danger] = "Email address not found."
      render 'new'
    end
  end

  def update

  end

  private

    def get_user
      @user = User.find_by email: params[:email]
    end

    # 确保用户是有效的
    def valid_user
      unless @user && @user.activated? && @user.authenticated?(:reset, params[:id])
        redirect_to root_url
      end
    end

    #检查重设令牌是否过期
    def check_expiration
      if @user.password_reset_expired?
        flash[:danger] = 'Password reset has expired.'
        redirect_to new_password_reset_path
      end
    end

end
