require "test_helper"

class UserMailerTest < ActionMailer::TestCase

  test "account_activation" do
    user = users(:Leo)
    user.activation_token = User.new_token
    mail = UserMailer.account_activation user
    assert_equal 'Account activation', mail.subject
    assert_equal [user.email], mail.to
    assert_equal ['noreply@example.com'], mail.from
    assert_match user.name, mail.body.encoded
    assert_match user.activation_token, mail.body.encoded
    assert_match CGI.escape(user.email), mail.body.encoded
  end

  test "password_rest" do
    user = users :Leo
    user.reset_token = User.new_token
    mail = UserMailer.password_rest user
    assert_equal 'Password reset', mail.subject
    assert_equal [user.email], mail.to
    assert_equal ['noreply@example.com'], mail.from
    assert_match user.reset_token, mail.body.encoded
    p mail.body.encoded
    assert_match CGI.escape(user.email), mail.body.encoded
  end

end