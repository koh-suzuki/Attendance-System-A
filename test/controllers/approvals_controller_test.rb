require 'test_helper'

class ApprovalsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get approvals_create_url
    assert_response :success
  end

end
