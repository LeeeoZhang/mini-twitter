require "test_helper"

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @admin = users :Leo
  end

  test 'unsuccessful edit' do
    get edit_user_path @admin
    log_in_as @admin
    assert_redirected_to edit_user_path @admin
    patch user_path @admin, params: { user: { name: '', email: 'foo@invalid', password: '123', password_confirmation: '321' } }
    assert_template 'users/edit'
    assert_select 'div.alert', text: 'The form contains 4 errors.'
  end

  test 'successful edit' do
    name = 'Edit_Leo'
    email = 'edit@example.com'
    get edit_user_path @admin
    log_in_as @admin
    assert_redirected_to edit_user_path @admin
    patch user_path @admin, params: { user: { name: name, email: email, password: '', password_confirmation: '' } }
    assert_not flash.empty?
    assert_redirected_to @admin
    @admin.reload
    assert_equal @admin.name, name
    assert_equal @admin.email, email
  end

end
