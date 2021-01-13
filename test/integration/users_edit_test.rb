require "test_helper"

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users :Leo
  end

  test 'unsuccessful edit' do
    get edit_user_path @user
    patch user_path @user, params: { user: { name: '', email: 'foo@invalid', password: '123', password_confirmation: '321' } }
    assert_template 'users/edit'
  end

end
