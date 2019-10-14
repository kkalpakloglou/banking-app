require 'test_helper'

class LoginUserTest < ActionDispatch::IntegrationTest
  test 'should be redirected to sign in, if they are not connected' do
    get root_path
    assert_redirected_to user_session_url
  end

  test 'should return with error if login credentials are incorrect' do
    get user_session_path
    assert_equal 200, status
    @user = users(:default)
    sign_in(User.new)
    assert_equal 200, status
    assert_not_nil flash[:alert]
  end

  test 'signed in user should be redirected to root_path' do
    get user_session_path
    assert_equal 200, status
    @user = users(:default)
    sign_in(@user)

    assert_redirected_to root_url
  end
end
