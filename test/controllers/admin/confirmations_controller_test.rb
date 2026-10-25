require 'test_helper'

class Admin::ConfirmationsControllerTest < ActionDispatch::IntegrationTest
  test 'should show confirmation page with invalid token' do
    get admin_confirmation_path, params: { confirmation_token: 'invalid-token' }

    assert_response :success
  end

  test 'should redirect to the default path after confirmation' do
    raw_token, encrypted_token = Devise.token_generator.generate(Admin, :confirmation_token)
    admin = Admin.create!(
      name: 'Unconfirmed admin',
      email: 'unconfirmed-admin@example.com',
      password: '@admin1234',
      confirmation_token: encrypted_token,
      confirmation_sent_at: Time.current
    )

    get admin_confirmation_path, params: { confirmation_token: raw_token }

    assert_redirected_to new_admin_session_path
    assert_predicate admin.reload, :confirmed?
  end
end
