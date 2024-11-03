require "test_helper"

class StudentTest < ActiveSupport::TestCase
  setup do
    @student = Student.new(name: "Example User", email: "student@example.com", phone: "11999999999")
  end
  test "should be valid" do
    assert @student.valid?
  end

  test "name should be present" do
    @student.name = " "
    refute @student.valid?
  end

  test "email should be present" do
    @student.email = " "
    refute @student.valid?
  end

  test "phone should be present" do
    @student.phone = " "
    refute @student.valid?
  end

  test "email should be unique" do
    duplicate_student = @student.dup
    @student.save
    refute duplicate_student.valid?
  end

  test "email should be valid" do
    @student.email = "invalid"
    refute @student.valid?
  end

  test "phone should have a minimum length" do
    @student.phone = "1" * 9
    refute @student.valid?
  end

  test "phone should have a maximum length" do
    @student.phone = "1" * 12
    refute @student.valid?
  end
end
