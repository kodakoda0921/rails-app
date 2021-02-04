class FlashChannel < ApplicationCable::Channel
  def subscribed
    stream_from "flash_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
