require 'test_helper'

class Admin::StudentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:admin_one), scope: :admin
  end

  test 'should get index' do
    get admin_students_path
    assert_response :success
  end

  test 'should update student name' do
    student = users(:student_one)

    patch admin_student_path(student), params: { student: { name: 'UpdatedName' } }
    follow_redirect!

    assert_response :success

    student.reload

    assert flash.notice.present?
    assert_equal 'UpdatedName', student.name
  end

  test 'should update student contacted' do
    student = users(:student_one)

    patch admin_student_path(student), params: { student: { contacted: true } }
    follow_redirect!

    assert_response :success

    student.reload

    assert flash.notice.present?
    assert student.contacted?
  end

  test 'should update student enrolled' do
    student = users(:student_one)

    patch admin_student_path(student), params: { student: { enrolled: true } }
    follow_redirect!

    assert_response :success

    student.reload

    assert flash.notice.present?
    assert student.enrolled?
  end

  test 'should not update with invalid params' do
    student = users(:student_one)

    patch admin_student_path(student), params: { student: { phone: 'invalid_phone' } }

    assert_response :unprocessable_entity
    assert flash.alert.present?
  end
end
