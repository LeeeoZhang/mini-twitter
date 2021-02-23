require "test_helper"

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest

  def setup
    @user = users :Leo
  end

  test 'micropost interface' do
    log_in_as @user
    get root_path
    assert_select 'div.pagination'
    assert_select 'input[type=file]'
    # 提交无效的微博
    assert_no_difference 'Micropost.count' do
      post microposts_path, params: { micropost: { content: '' } }
    end
    assert_select 'div#error_explanation'
    assert_select 'a[href=?]', '/?page=2' # 确认分页正确
    # 提交有效微博
    content = 'this micropost really ties the room together'
    image = fixture_file_upload 'test/fixtures/kitten.jpg', 'image/jpeg'
    assert_difference 'Micropost.count', 1 do
      post microposts_path, params: { micropost: { content: content, image: image } }
    end
    assert_redirected_to root_path
    follow_redirect!
    assert_match content, response.body
    # 删除微博
    assert_select 'a', text: 'delete'
    first_micropost = @user.microposts.paginate(page: 1).first
    assert_difference 'Micropost.count', -1 do
      delete micropost_path first_micropost
    end
    # 访问另外一个用户的主页，不会出现删除链接
    get user_path users(:Leo2)
    assert_select 'a', text: 'delete', count: 0
  end

  test 'micropost sidebar content' do
    log_in_as users :Leo3
    get root_path
    assert_match '1 micropost', response.body # Leo3发布了1个微博
    leo2 = users :Leo2
    log_in_as leo2
    get root_path
    assert_match '0 micropost', response.body # Leo2发布了0个微博
    leo2.microposts.create! content: 'first post' # Leo2发布一个微博
    get root_path
    assert_match '1 micropost', response.body # Leo2发布了1个微博
  end

end
