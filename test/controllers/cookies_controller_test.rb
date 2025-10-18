require 'test_helper'

class CookiesControllerTest < ActionDispatch::IntegrationTest
  test 'should accept cookies' do
    post cookies_accept_path

    assert_equal 'true', cookies[:cookies_accepted]
    assert_response :redirect
  end
end
