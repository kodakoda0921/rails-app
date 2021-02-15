class SearchController < ApplicationController
  def index
    if logged_in?
      logger.error(params)

      if params[:function] == "new"
        if params[:value].empty?
          flash.now[:info] = "検索値を入力して下さい"
          ActionCable.server.broadcast("flash_channel", { flash: flash, user_id: current_user.id })
          return
        else
          if params[:tab]
            @tab_id = SecureRandom.urlsafe_base64
          end
          radio_val = params[:radio_val]
          logger.error(radio_val)
          page_tab_id = params[:tab_id]
          @search_value = params[:value]
          @current_user = current_user
          @post_comment = PostComment.new
          if radio_val == "follow_user_only"
            @micropost_search = @current_user.only_follow_user_micropost_include_params(params[:value])
            @search_user_list = @current_user.only_follow_user_include_params(params[:value])
          else
            @micropost_search = Micropost.where('content like ?', "%#{params[:value]}%")
            @search_user_list = @current_user.all_user_include_params_name_and_notes(params[:value])
          end
          ActionCable.server.broadcast("search_channel", { microposts: microposts_html_template(@micropost_search), users: users_html_template(@search_user_list, current_user), current_user_id: current_user.id.to_s, tab_id: page_tab_id, value: @search_value, method: "new" })
        end
      end
      if params[:function] == "add"
        page_tab_id = params[:tab_id]
        radio_val = params[:radio_val]
        if params[:micropost].present?
          if radio_val == "follow_user_only"
            find_target_micropost = current_user.only_follow_user_micropost_include_params(params[:value])
          else
            find_target_micropost = Micropost.where('content like ?', "%#{params[:value]}%")
          end
          target_micropost = find_target_micropost.find_by(id: params[:micropost])
          if target_micropost
            current_user = User.find_by(id: params[:current_user])
            ActionCable.server.broadcast("search_channel", { micropost: micropost_html_template(target_micropost, current_user), current_user_id: params[:current_user], tab_id: page_tab_id, value: params[:value], method: "add" })
          end
        end
        if params[:user].present?
          search_user_list = current_user.all_user_include_params_name_and_notes(params[:value])
          # target_user = search_user_list.find_by(id: params[:user])
          #targetのuserが条件に一致してもしなくても毎回ブロードキャストする
          ActionCable.server.broadcast("search_channel", { users: users_html_template(search_user_list, current_user), current_user_id: params[:current_user], tab_id: page_tab_id, value: params[:value], method: "add" })
        end
      end
    else
      redirect_to new_session_path
    end
  end

  private

  def microposts_html_template(microposts)
    ApplicationController.renderer.render partial: "microposts/microposts_index", locals: { microposts_index: microposts, current_user: current_user, post_comment: PostComment.new }
  end

  def micropost_html_template(micropost, current_user)
    ApplicationController.renderer.render partial: "microposts/microposts_create", locals: { micropost: micropost, current_user: current_user, post_comment: PostComment.new }
  end

  def users_html_template(users, current_user)
    ApplicationController.renderer.render partial: "users/user_index", locals: { search_user_list: users, current_user: current_user }
  end
end
