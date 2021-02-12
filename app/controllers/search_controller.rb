class SearchController < ApplicationController
  def index
    if logged_in?
      if params[:value].empty?
        flash.now[:info] = "検索値を入力して下さい"
        ActionCable.server.broadcast("flash_channel", { flash: flash, user_id: current_user.id })
        return
      else
        @button = true
        if params[:tab]
          @tab_id = SecureRandom.urlsafe_base64
          @button = false
        end
        page_tab_id = params[:tab_id]
        @search_value = params[:value]
        @current_user = current_user
        @micropost_search = Micropost.where('content like ?', "%#{params[:value]}%")
        @post_comment = PostComment.new
        ActionCable.server.broadcast("search_channel", { microposts: microposts_html_template(@micropost_search), current_user_id: current_user.id.to_s, tab_id: page_tab_id, value: @search_value, method: "new" })
        return
      end
    else
      redirect_to new_session_path
    end
  end

  def microposts_html_template(microposts)
    ApplicationController.renderer.render partial: "microposts/microposts_index", locals: { microposts_index: microposts, current_user: current_user, post_comment: PostComment.new }
  end
end