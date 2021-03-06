require "test_helper"

class UserTest < ActiveSupport::TestCase

  def setup
    @admin = User.new(name: 'Test User', email: 'test@example.com', password: 'foobar', password_confirmation: 'foobar')
  end

  test 'should be valid' do
    assert @admin.valid?
  end

  test 'name should be present' do
    @admin.name = ''
    assert_not @admin.valid?
  end

  test 'email should be present' do
    @admin.email = ''
    assert_not @admin.valid?
  end

  test 'name should not be to long' do
    @admin.name = 'a' * 51
    assert_not @admin.valid?
  end

  test 'email should not be to long' do
    @admin.name = 'a' * 244 + '@example.com'
    assert_not @admin.valid?
  end

  test 'email validation should accept valid addresses' do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @admin.email = valid_address
      assert @admin.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.foo@bar_baz.com foo@bar+baz.com foo@bar..com]
    invalid_addresses.each do |invalid_address|
      @admin.email = invalid_address
      assert_not @admin.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test 'email address should be unique' do
    duplicate_user = @admin.dup
    @admin.save
    assert_not duplicate_user.valid?
  end

  test 'email address should be save as lower-case' do
    test_email = 'TESt@eXamplE.cOm'
    @admin.email = test_email
    @admin.save
    assert_equal @admin.reload.email, test_email.downcase
  end

  test 'password should be present' do
    @admin.password = @admin.password_confirmation = ' ' * 6
    assert_not @admin.valid?
  end

  test 'password should have a minimum length' do
    @admin.password = @admin.password_confirmation = 'a' * 5
    assert_not @admin.valid?
  end

  test 'authenticated? should return false for a user with nil digest' do
    assert_not @admin.authenticated?(:remember, ''), ''
  end

  test 'associated microposts should be destroyed' do
    @admin.save
    @admin.microposts.create!(content: 'test content')
    assert_difference 'Micropost.count', -1 do
      @admin.destroy
    end
  end

  test 'should follow and unfollow a user' do
    user1 = users :Leo
    user2 = users :Leo2
    assert_not user1.following? user2
    user1.follow user2
    assert user1.following? user2
    assert user2.followers.include? user1
    user1.unfollow user2
    assert_not user1.following? user2
  end

  test 'feed should have right post' do
    leo = users :Leo
    leo2 = users :Leo2
    leo3 = users :Leo3
    # 关注用户的微博
    leo3.microposts.each do |post|
      assert leo.feed.include? post
    end
    # 自己的微博
    leo.microposts.each do |post|
      assert leo.feed.include? post
    end
    # 未关注用户的微博
    leo2.microposts.each do |post|
      assert_not leo.feed.include? post
    end
  end

end
