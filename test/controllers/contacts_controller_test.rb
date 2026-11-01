require 'test_helper'

class ContactsControllerTest < ActionDispatch::IntegrationTest
  test 'should get new' do
    get new_contact_path

    assert_response :success
  end

  test 'should not create contact without course params' do
    assert_no_changes('Student.count') do
      post contacts_url, params: {
        contact: {
          name: 'joão',
          email: 'joao@joao.com',
          phone: '11912345678' },
          enrollments: {
            course_ids: [] } }
    end

    assert_response :unprocessable_content
  end

  test 'should not create contact without email' do
    assert_no_changes('Student.count') do
      post contacts_url, params: {
        contact: {
          name: 'joão',
          email: '',
          phone: '11912345678' },
          enrollments: {
            course_ids: [courses(:one).id] } }
    end

    assert_response :unprocessable_content
  end

  test 'should create contact with course params' do
    ENV['ADMIN_EMAILS_TO_NOTIFY'] = [users(:admin_one).email, users(:student_one).email].join(';')
    assert_changes('Student.count') do
      assert_emails 2 do
        post contacts_url, params: {
          contact: {
            name: 'joão',
            email: 'joao@joao.com',
            phone: '11912345678' },
            enrollments: {
              course_ids: [courses(:one).id] } }
      end
    end
    assert_includes ActionMailer::Base.deliveries.map(&:to).flatten, users(:admin_one).email, 'joao@joao.com'
    assert_not_includes ActionMailer::Base.deliveries.map(&:to).flatten, users(:student_one).email

    follow_redirect!

    assert_response :success
  end

  test 'should normalize formatted phone numbers' do
    assert_changes('Student.count') do
      post contacts_url, params: {
        contact: {
          name: 'joão',
          email: 'formatted@joao.com',
          phone: '(11) 99999-9999' },
        enrollments: {
          course_ids: [courses(:one).id] } }
    end

    assert_equal '11999999999', Student.find_by(email: 'formatted@joao.com').phone
  end
end
