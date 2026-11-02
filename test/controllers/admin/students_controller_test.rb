require 'test_helper'

class Admin::StudentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:admin_one), scope: :admin
  end

  test 'should get index' do
    get admin_students_path
    assert_response :success
  end

  test 'should get new' do
    get new_admin_student_path
    assert_response :success
  end

  test 'should create student with normalized phone and document' do
    assert_difference('Student.count') do
      post admin_students_path, params: {
        student: {
          name: 'New Student',
          email: 'new@student.com',
          phone: '(11) 99999-8888',
          document: '123.456.789-09'
        }
      }
    end

    student = Student.find_by(email: 'new@student.com')
    assert_redirected_to admin_students_path
    assert_equal '11999998888', student.phone
    assert_equal '12345678909', student.document
  end

  test 'should not create student with invalid params' do
    assert_no_difference('Student.count') do
      post admin_students_path, params: {
        student: {
          name: 'Invalid Student',
          email: 'invalid@student.com'
        }
      }
    end

    assert_response :unprocessable_entity
    assert flash.alert.present?
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

  test 'should update student document and normalize phone' do
    student = users(:student_one)

    patch admin_student_path(student), params: {
      student: { phone: '(11) 98888-7777', document: '12.345.678/0001-90' }
    }
    follow_redirect!

    assert_response :success
    student.reload
    assert_equal '11988887777', student.phone
    assert_equal '12345678000190', student.document
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

    patch admin_student_path(student), params: { student: { phone: '123' } }

    assert_response :unprocessable_entity
    assert flash.alert.present?
  end
end
