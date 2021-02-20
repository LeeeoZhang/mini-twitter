require "test_helper"

class UsersIndexTest < ActionDispatch::IntegrationTest

  def setup
    @admin = users :Leo
    @non_admin = users :Leo2
    @non_activate_user = users :Leo4
  end

  test 'index as admin including pagination and delete link' do
    log_in_as @admin
    get users_path
    assert_template 'users/index'
    assert_select 'ul.pagination', count: 2
    first_page_users = User.paginate page: 1
    first_page_users.each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
      unless user == @admin
        assert_select 'a[href=?]', user_path(user), text: 'delete'
      end
    end
    assert_difference 'User.count', -1 do
      delete user_path @non_admin
    end
  end

  test 'index as non-admin' do
    log_in_as @non_admin
    get users_path
    assert_select 'a', text: 'delete', count: 0
  end

  test 'users should be activated' do
    log_in_as @admin
    get users_path
    assert_template 'users/index'
    assigns(:users).each do |user|
      assert user.activated?
    end
  end

  test 'should redirect to root if visit a not activate user' do
    get user_path @non_activate_user
    assert_redirected_to root_path
  end

end
