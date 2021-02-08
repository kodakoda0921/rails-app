require "test_helper"

class FrameControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get frame_show_url
    assert_response :success
  end
end
