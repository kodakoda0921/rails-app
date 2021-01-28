class SessionsController < ApplicationController
  layout "default"

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      if user.activated?
        log_in(user)
        # params[:session][:remember_me] == "1" ? remember(user) : forget(user)
        redirect_to root_path
      else
        message = "アカウントが有効化されていません！"
        message += "登録時のメールを確認し、アカウント有効化リンクを開いてください"
        flash[:warning] = message
        render "new"
      end
    else
      flash.now[:danger] = "emailまたはパスワードに誤りがあります"
      render "new"
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path
  end
end
