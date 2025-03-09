require "test_helper"

class Admin::CoursesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in users(:admin_one), scope: :admin
  end

  test "should get index" do
    get admin_courses_path

    assert_response :success
    assert_match courses(:one).name, @response.body
    assert_match courses(:two).name, @response.body
  end

  test "should get new" do
    get new_admin_course_path

    assert_response :success
  end

  test "should create course" do
    assert_difference("Course.count") do
      post admin_courses_path, params: {
        course: {
          name: "New Course",
          description: "This is a new course.",
          featured: 1
        }
      }
    end

    assert_redirected_to admin_courses_path
    follow_redirect!

    assert_match "New Course", @response.body
    assert_equal "Curso cadastrado com sucesso", flash[:notice]
  end

  test "should not create course with invalid data" do
    assert_no_difference("Course.count") do
      post admin_courses_path, params: {
        course: {
          name: "",
          description: "",
          featured: 1
        }
      }
    end

    assert_response :unprocessable_entity
    assert_match "não pode ficar em branco", @response.body
  end

  test "should get edit" do
    course = courses(:one)
    get edit_admin_course_path(course)

    assert_response :success
    assert_match course.name, @response.body
    assert_match course.description, @response.body
    assert_match course.featured.to_s, @response.body
  end

  test "should update course" do
    course = courses(:one)
    patch admin_course_path(course), params: {
      course: {
        name: "Updated Course",
        description: "This is an updated course.",
        featured: 1
      }
    }

    assert_redirected_to admin_courses_path
    follow_redirect!

    assert_match "Updated Course", @response.body
    assert_equal "Curso atualizado com sucesso", flash[:notice]
    course.reload
    assert_equal "Updated Course", course.name
    assert_equal "This is an updated course.", course.description
    assert_equal "1", course.featured
  end

  test "should not update course with invalid data" do
    course = courses(:one)
    patch admin_course_path(course), params: {
      course: {
        name: "",
        description: "",
        featured: 1
      }
    }

    assert_response :unprocessable_entity
    assert_match "não pode ficar em branco", @response.body
    course.reload
    assert_equal courses(:one).name, course.name
    assert_equal courses(:one).description, course.description
    assert_equal courses(:one).featured, course.featured
  end
end
