class UsersController < ApplicationController
  layout "default", only: [:new, :create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if params[:user][:terms] == "1"
      if @user.save && Profile.create(user_id: @user.id)
        @user.send_activation_email
        flash[:info] = "確認用のメールを送りました。ご確認の上、記載のリンクをクリックしてください。"
        redirect_to new_user_path
      else
        flash[:danger] = @user.errors.full_messages.to_s.gsub(",", "<br>").gsub("[", "").gsub("]", "").gsub('"', "").html_safe
        redirect_to new_user_path
      end
    else
      flash[:info] = "利用規約に同意していません。"
      redirect_to new_user_path
    end

  end

  def home
    if logged_in?
      @current_user = current_user
      @microposts = current_user.microposts
      @profiles = current_user.profiles
      @post_comment = PostComment.new
    else
      redirect_to new_session_path
    end
  end

  def index
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.build
  end

  def update

    if params[:preview]
      @user = current_user
      @image_flg = false
      @back_ground_flg = false
      if params[:user]
        if params[:user][:image].present?
          @user.image_preview.attach(params[:user][:image])
          if @user.errors.any?
            flash[:danger] = @user.errors.full_messages.to_s.gsub(",", "<br>").gsub("[", "").gsub("]", "").gsub('"', "").html_safe
            ActionCable.server.broadcast("flash_channel", { flash: flash_template(flash), user_id: @user.id })
          end
          @image_flg = true
        end
        if params[:user][:back_ground].present?
          @user.back_ground_preview.attach(params[:user][:back_ground])
          if @user.errors.any?
            flash[:danger] = @user.errors.full_messages.to_s.gsub(",", "<br>").gsub("[", "").gsub("]", "").gsub('"', "").html_safe
            ActionCable.server.broadcast("flash_channel", { flash: flash_template(flash), user_id: @user.id })
          end
          @back_ground_flg = true
        end
      end
    end
    if params[:save]
      @user = current_user
      @user.back_ground.attach(params[:user][:back_ground]) if params[:user][:back_ground]
      @user.image.attach(params[:user][:image]) if params[:user][:image]
      if @user.update(user_params)
        flash[:success] = "プロフィールを更新しました！"
        redirect_to root_path
      else
        if @user.errors.any?
          flash[:danger] = @user.errors.full_messages.to_s.gsub(",", "<br>").gsub("[", "").gsub("]", "").gsub('"', "").html_safe
          redirect_to root_path
        else
          flash[:danger] = "不明なエラーが発生しました"
          redirect_to root_path
        end
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation,
                                 profiles_attributes: [:id, :location, :skills, :notes, :url, :job],
                                 image_attributes: [:image],
                                 back_ground_attributes: [:back_ground])
  end
end
