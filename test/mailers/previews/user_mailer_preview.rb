# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/account_activation
  def account_activation
    user = User.first
    user.activation_token = User.new_token
    UserMailer.account_activation user
  end

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/password_rest
  def password_rest
    user = User.first
    user.reset_token = User.new_token
    UserMailer.password_rest user
  end

end
