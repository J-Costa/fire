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

  test "marketing image URL should return correct path when attached" do
    course_with_image = courses(:two)
    expected_url = Rails.application.routes.url_helpers.url_for(course_with_image.marketing)

    assert course_with_image.marketing.attached?
    assert_equal expected_url, course_with_image.marketing_image_url
  end

  test "marketing image URL should return default path when not attached" do
    course_without_image = courses(:one)

    refute course_without_image.marketing.attached?
    assert_equal ActionController::Base.helpers.asset_path("default_course_image.jpeg"), course_without_image.marketing_image_url
  end
end
