require "test_helper"

class Admin::EnrollmentsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in users(:admin_one), scope: :admin
  end

  test "should get index" do
    get admin_enrollments_path

    assert_response :success
    assert_match users(:student_one).email, @response.body
    assert_match courses(:one).name, @response.body
    assert_match courses(:two).name, @response.body
  end
end
