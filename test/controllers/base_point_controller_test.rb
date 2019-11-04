require 'test_helper'

class BasePointControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get base_point_index_url
    assert_response :success
  end

end
