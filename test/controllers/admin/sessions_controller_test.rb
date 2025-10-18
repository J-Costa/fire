require 'test_helper'

class Admin::SessionsControllerTest < ActionDispatch::IntegrationTest
  test 'should get new' do
    get new_admin_session_url

    assert_response :success
  end

  test 'should create session' do
    admin = users(:admin_one)
    post admin_session_path, params: { admin: { email: admin.email, password: '@admin1234' } }

    follow_redirect!
    assert_response :success
    assert_equal 'Login efetuado com sucesso!', flash[:notice]
  end

  test 'should destroy session' do
    delete destroy_admin_session_path

    assert_redirected_to root_path
    assert_equal 'Saiu com sucesso.', flash[:notice]
  end
end
