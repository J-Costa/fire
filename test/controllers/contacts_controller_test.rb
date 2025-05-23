require "test_helper"

class ContactsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get new_contact_path

    assert_response :success
  end

  test "should not create contact without course params" do
    assert_no_changes("Student.count") do
      post contacts_url, params: {
        contact: {
          name: "joão",
          email: "joao@joao.com",
          phone: "11912345678" },
          enrollments: {
            course_ids: [] } }
    end

    assert_response :unprocessable_entity
  end

  test "should not create contact without email" do
    assert_no_changes("Student.count") do
      post contacts_url, params: {
        contact: {
          name: "joão",
          email: "",
          phone: "11912345678" },
          enrollments: {
            course_ids: [courses(:one).id] } }
    end

    assert_response :unprocessable_entity
  end

  test "should create contact with course params" do
    assert_changes("Student.count") do
      assert_emails 1 do
        post contacts_url, params: {
          contact: {
            name: "joão",
            email: "joao@joao.com",
            phone: "11912345678" },
            enrollments: {
              course_ids: [courses(:one).id] } }
      end
    end

    follow_redirect!

    assert_response :success
  end
end
