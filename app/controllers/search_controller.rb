class SearchController < ApplicationController
  def index
    if logged_in?
      if params[:tab]
        @tab_id = SecureRandom.urlsafe_base64
        logger.error(@tab_id)
      end
      page_tab_id = params[:tab_id]
      @search_value = params[:value]
      @current_user = current_user
      @micropost_search = Micropost.where('content like ?', "%#{params[:value]}%")
      logger.error(@micropost_search)

      @post_comment = PostComment.new
      ActionCable.server.broadcast("search_channel_#{@page_tab_id}", { microposts: microposts_html_template(@micropost_search), current_user_id: current_user.id.to_s, tab_id: page_tab_id })
    else
      redirect_to new_session_path
    end
  end

  def microposts_html_template(microposts)
    ApplicationController.renderer.render partial: "microposts/microposts_index", locals: { microposts_index: microposts, current_user: current_user, post_comment: PostComment.new }
  end
end
