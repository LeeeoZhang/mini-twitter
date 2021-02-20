require "test_helper"

class UsersSignupTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear
  end

  test 'invalid signup information' do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name: '', email: 'user@invalid', password: '123', password_confirmation: '321' } }
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors'
  end

  test 'valid signup information with account activation' do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path params: { user: { name: 'Test_User', email: 'user@valid.com', password: '123456', password_confirmation: '123456' } }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)
    assert_not user.activated?
    # 尝试在激活前登陆
    log_in_as user
    assert_not is_logged_in?
    # 尝试无效的激活token
    get edit_account_activation_path 'invalid token', email: user.email
    assert_not is_logged_in?
    # token有效，email无效
    get edit_account_activation_path user.activation_token, email: 'invalid email'
    assert_not is_logged_in?
    # 正确激活
    get edit_account_activation_path user.activation_token, email: user.email
    assert user.reload.activated?
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
    assert_not flash.empty?
    assert_select 'div.alert'
  end

end
