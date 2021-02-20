require "test_helper"

class SiteLayoutTest < ActionDispatch::IntegrationTest

  def setup
    @admin = users :Leo
  end

  test "layout link" do
    get root_path
    assert_template 'static_page/home'
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
    get contact_path
    assert_select "title", full_title("Contact")
    get signup_path
    assert_select "title", full_title("Sign Up")
  end

  test 'after logged in layout link' do
    log_in_as @admin
    assert_redirected_to @admin
    follow_redirect!
    assert_select "a[href=?]", users_path
    assert_select "a[href=?]", edit_user_path(@admin)
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@admin)
  end

end
