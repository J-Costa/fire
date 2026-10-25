require 'test_helper'

class Admin::PasswordsControllerTest < ActionDispatch::IntegrationTest
  test 'should get new password form' do
    get new_admin_password_path

    assert_response :success
  end

  test 'should get edit password form with invalid token' do
    get edit_admin_password_path, params: { reset_password_token: 'invalid-token' }

    assert_response :success
  end

  test 'should update password with invalid token' do
    patch admin_password_path, params: {
      admin: {
        reset_password_token: 'invalid-token',
        password: 'new-password',
        password_confirmation: 'new-password'
      }
    }

    assert_response :unprocessable_content
  end
end
