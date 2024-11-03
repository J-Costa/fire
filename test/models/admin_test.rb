require "test_helper"

class AdminTest < ActiveSupport::TestCase
  test "admin is valid" do
    admin = Admin.new(name: "admin", email: "new_admin@admin.com", password: "password")

    assert admin.valid?
  end

  test "email must be unique" do
    duplicate_admin = Admin.new(name: "admin", email: users(:admin_one).email, password: "password")

    assert_not duplicate_admin.valid?
  end
end
