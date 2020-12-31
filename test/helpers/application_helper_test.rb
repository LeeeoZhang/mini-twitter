require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase

  test 'full title helper' do
    assert_equal full_title, 'Mini Twitter'
    assert_equal full_title('Help'), 'Mini Twitter | Help'
  end

end