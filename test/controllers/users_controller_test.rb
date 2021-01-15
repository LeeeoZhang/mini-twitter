require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users :Leo
    @user2 = users :Leo2
  end

  test "should get new" do
    get signup_path
    assert_response :success
  end

  test 'should redirect edit when no logged in' do
    get edit_user_path @user
    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test 'should redirect update when no logged in' do
    patch user_path @user, params: { user: { name: @user.name, email: @user.email } }
    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test 'should redirect edit when logged in as wrong user' do
    log_in_as @user2
    get edit_user_path @user
    assert flash.empty?
    assert_redirected_to root_path
  end

  test 'should redirect update when logged in as wrong user' do
    log_in_as @user2
    patch user_path @user, params: { user: { name: @user.name, email: @user.email } }
    assert flash.empty?
    assert_redirected_to root_path
  end

  test 'should redirect index when no logged in' do
    get users_path
    assert_redirected_to login_path
  end

end
