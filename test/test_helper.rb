ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

class ActiveSupport::TestCase
  # Chạy test song song để tăng tốc độ
  parallelize(workers: :number_of_processors)

  # Tự động nạp tất cả dữ liệu mẫu trong thư mục test/fixtures/*.yml
  fixtures :all

  # --- CÁC HÀM BỔ TRỢ CHO BÀI TEST ---

  # Trả về true nếu người dùng đã đăng nhập trong bài test
  def logged_in?
    !session[:user_id].nil?
  end

  # Đăng nhập với tư cách một người dùng cụ thể
  def log_in_as(user, password: "password", remember_me: "1")
    post login_path, params: { session: { email: user.email,
                                         password: password,
                                         remember_me: remember_me } }
  end
end
