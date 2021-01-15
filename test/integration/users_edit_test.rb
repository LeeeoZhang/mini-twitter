require "test_helper"

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users :Leo
  end

  test 'unsuccessful edit' do
    get edit_user_path @user
    log_in_as @user
    assert_redirected_to edit_user_path @user
    patch user_path @user, params: { user: { name: '', email: 'foo@invalid', password: '123', password_confirmation: '321' } }
    assert_template 'users/edit'
    assert_select 'div.alert', text: 'The form contains 4 errors.'
  end

  test 'successful edit' do
    get edit_user_path @user
    log_in_as @user
    assert_redirected_to edit_user_path @user
    name = 'Edit_Leo'
    email = 'edit@example.com'
    patch user_path @user, params: { user: { name: name, email: email, password: '', password_confirmation: '' } }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal @user.name, name
    assert_equal @user.email, email
  end

end
