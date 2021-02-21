require "test_helper"

class PasswordResetTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear
    @user = users :Leo
  end

  test 'password resets' do
    get new_password_reset_path
    assert_template 'password_resets/new'
    assert_select 'input[name=?]', 'password_reset[email]'
    # 测试电子邮件地址无效
    post password_resets_path params: { password_reset: { email: '' } }
    assert_not flash.empty?
    assert_template 'password_resets/new'
    # 测试电子邮件有效
    post password_resets_path params: { password_reset: { email: @user.email } }
    assert_not_equal @user.reset_digest, @user.reload.reset_digest
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not flash.empty?
    assert_redirected_to root_path
    user = assigns(:user)
    # 重置密码表单邮件地址错误
    get edit_password_reset_path(user.reset_token, email: '')
    assert_redirected_to root_path
    # 用户未激活
    user.toggle!(:activated)
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_redirected_to root_path
    user.toggle!(:activated)
    # 重置密码表单邮件地址正确，token错误
    get edit_password_reset_path('xx', email: user.email)
    assert_redirected_to root_path
    # 重置密码表单邮件地址正确，token正确
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_template 'password_resets/edit'
    assert_select 'input[name=email][type=hidden][value=?]', user.email # 确认页面中有一个hidden的input
    # 密码和密码确认不匹配
    patch password_reset_path(user.reset_token), params: { email: user.email, user: { password: '12345678', password_confirmation: '87654321' } }
    assert_select 'div#error_explanation'
    # 密码为空
    patch password_reset_path(user.reset_token), params: { email: user.email, user: { password: '', password_confirmation: '' } }
    assert_select 'div#error_explanation'
    # 密码和密码确认有效
    patch password_reset_path(user.reset_token), params: { email: user.email, user: { password: '12345678', password_confirmation: '12345678' } }
    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test 'expired token' do
    get new_password_reset_path
    post password_resets_path, params: { password_reset: { email: @user.email } }
    @user = assigns(:user)
    @user.update_attribute :reset_send_at, 3.hours.ago
    patch password_reset_path(@user.reset_token), params: { email: @user.email, user: { password: 'foobar', password_confirmation: 'foobar' } }
    assert_response :redirect
    assert_not flash.empty?
    follow_redirect!
    assert_match 'expired', response.body
  end

end
