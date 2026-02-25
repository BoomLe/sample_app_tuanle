require "test_helper"

class SiteLayoutTest < ActionDispatch::IntegrationTest
  test "layout links" do
    # 1. Đi đến trang chủ
    get root_path

    # 2. Kiểm tra xem có đúng là đang render file home.html.erb không
    assert_template "static_pages/home"

    # 3. Kiểm tra xem các đường link có xuất hiện trên màn hình không
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
  end
end
