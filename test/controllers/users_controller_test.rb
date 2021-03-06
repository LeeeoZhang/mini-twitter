require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest

  def setup
    @admin = users :Leo
    @user2 = users :Leo2
  end

  test "should get new" do
    get signup_path
    assert_response :success
  end

  test 'should redirect edit when no logged in' do
    get edit_user_path @admin
    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test 'should redirect update when no logged in' do
    patch user_path @admin, params: { admin: { name: @admin.name, email: @admin.email } }
    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test 'should redirect edit when logged in as wrong user' do
    log_in_as @user2
    get edit_user_path @admin
    assert flash.empty?
    assert_redirected_to root_path
  end

  test 'should redirect update when logged in as wrong user' do
    log_in_as @user2
    patch user_path @admin, params: { user: { name: @admin.name, email: @admin.email } }
    assert flash.empty?
    assert_redirected_to root_path
  end

  test 'should redirect index when no logged in' do
    get users_path
    assert_redirected_to login_path
  end

  test 'should not allow the admin attribute to be edited via the web' do
    log_in_as @user2
    assert_not @user2.admin?
    patch user_path(@user2), params: { user: { password: 'password', password_confirmation: 'password', admin: true } }
    assert_not @user2.admin?
  end

  test 'should redirect destroy when not logged in' do
    assert_no_difference 'User.count' do
      delete user_path @admin
    end
    assert_redirected_to login_path
  end

  test 'should redirect destroy when logged in as a non-admin' do
    log_in_as @user2
    assert_no_difference 'User.count' do
      delete user_path @admin
    end
    assert_redirected_to root_url
  end

  test 'should redirect following when not logged in' do
    get following_user_path @admin
    assert_redirected_to login_path
  end

  test 'should redirect followers when not logged in' do
    get followers_user_path @admin
    assert_redirected_to login_path
  end

end
