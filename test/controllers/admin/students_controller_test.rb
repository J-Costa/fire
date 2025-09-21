require "test_helper"

class Admin::StudentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:admin_one), scope: :admin
  end

  test "should get index" do
    get admin_students_path
    assert_response :success
  end

  test "should get show" do
    skip "not implemented yet"
    get admin_student_show_url
    assert_response :success
  end
end
