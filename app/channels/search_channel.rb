class SearchChannel < ApplicationCable::Channel
  def subscribed
    stream_from "search_channel_#{params[:room]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def receive
    param[:tab_id]
  end
end
