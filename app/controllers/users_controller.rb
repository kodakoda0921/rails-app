class UsersController < ApplicationController
  layout "default", only: [:new, :create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = "確認用のメールを送りました。ご確認の上、記載のリンクをクリックしてください。"
      redirect_to root_path
    else
      render "new"
    end

  end

  def home
    if logged_in?
      @current_user = current_user
    else
      redirect_to new_session_path
    end
  end

  def index
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
