class SessionsController < ApplicationController
  layout "default"

  def new

  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      if user.activated?
        log_in(user)
        params[:session][:remember_me] == "1" ? remember(user) : forget(user)
        flash[:success] = "ようこそ" + user.name + "さん"
        if user.authenticated?("remember", user.remember_token)
          flash[:info] = user.name + "さんのログイン情報は現在、クッキーに記憶されています"
        else
          flash[:info] = user.name + "さんのログイン情報は現在、クッキーに記憶されていません"
        end
        redirect_to root_path
      else
        message = "アカウントが有効化されていません！"
        message += "登録時のメールを確認し、アカウント有効化リンクを開いてください"
        flash[:warning] = message
        redirect_to root_path
      end
    else
      flash[:danger] = "emailまたはパスワードに誤りがあります"
      redirect_to root_path
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path
  end
end
