class PostCommentChannel < ApplicationCable::Channel
  def subscribed
    stream_from "post_comment_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
