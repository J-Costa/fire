require "test_helper"

class CourseTest < ActiveSupport::TestCase
  def setup
    @course = Course.new(name: "Example Course", description: "This is an example course description.", featured: 5)
  end

  test "should be valid" do
    assert @course.valid?
  end

  test "name should be present" do
    @course.name = " "

    refute @course.valid?
  end

  test "description should be present" do
    @course.description = " "

    refute @course.valid?
  end

  test "featured should be present" do
    @course.featured = nil

    refute @course.valid?
  end

  test "name should be unique" do
    duplicate_course = @course.dup
    @course.save

    refute duplicate_course.valid?
  end

  test "description should have a minimum length" do
    @course.description = "a" * 9

    refute @course.valid?
  end

  test "featured should be within range" do
    @course.featured = 10
    refute @course.valid?

    @course.featured = 0
    refute @course.valid?
  end
end
