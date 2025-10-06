require "test_helper"

class DashboardControllerTest < ActionDispatch::IntegrationTest
  include ActiveJob::TestHelper

  setup { clear_enqueued_jobs }
  teardown { clear_enqueued_jobs }

  test "should get welcome and track visit" do
    get root_path

    assert_response :success
  end

  test "should visualize courses" do
    get root_path

    assert_response :success
    assert_select "dt", courses(:one).name
    assert_select "dt", courses(:two).name
  end

  test "should get welcome when logged in" do
    sign_in users(:admin_one), scope: :admin
    get root_path

    assert_response :success
  end
end
