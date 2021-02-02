class PasswordResetsController < ApplicationController
  before_action :get_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]
  layout "default"

  def new
  end

  def edit

  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:success] = "入力されたメールアドレスにパスワードリセットリンクを送信しました。"
      redirect_to new_password_reset_path
    else
      flash[:danger] = "入力されたメールアドレスは存在しません。"
      redirect_to new_password_reset_path
    end
  end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, :blank)
      flash[:danger] = "パスワードを入力してください"
      render "edit"
    elsif @user.update(user_params)
      log_in @user
      flash[:success] = "パスワードが正常にリセットされました"
      redirect_to root_path
    else
      flash[:danger] = "パスワードの更新に失敗しました。入力したパスワードが一致していない可能性があります。"
      render "edit"
    end
  end
end

private

def user_params
  params.require(:user).permit(:password, :password_confirmation)
end

def get_user
  @user = User.find_by(email: params[:email].downcase)
end

def valid_user
  unless @user && @user.activated? && @user.authenticated?(:reset, params[:id])
    redirect_to root_path
  end
end

# 期限切れかどうかを確認する
def check_expiration
  if @user.password_reset_expired?
    flash[:danger] = "このリンクは期限切れです."
    redirect_to root_path
  end
end
