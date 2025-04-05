require "test_helper"

class CoursesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @course = courses(:one)
    @course_with_image = courses(:two)
    @course_without_image = courses(:one)
  end

  test "should get index" do
    get courses_url

    assert_response :success
  end

  test "should get index when there are no courses" do
    Enrollment.destroy_all
    Course.destroy_all

    get courses_url

    assert_response :success
  end

  test "should get index with courses ordered by featured" do
    Course.create(name: "Featured Course", description: "A featured course", featured: 9)
    Course.create(name: "Regular Course", description: "A regular course", featured: 8)

    get courses_url
    assert_response :success
  end

  test "should show course" do
    get course_url(@course)

    assert_response :success
  end

  test "should show course with image" do
    get course_url(@course_with_image)

    assert_response :success
    assert_select "img[src]" do |elements|
      assert elements.any? { |element| element.attributes["src"].value.include?(@course_with_image.marketing.filename.to_s) },
        "Expected to find the course marketing image on the page"
    end
  end

  test "should show course without image" do
    get course_url(@course_without_image)

    assert_response :success
    refute @course_without_image.marketing.attached?
  end
end
