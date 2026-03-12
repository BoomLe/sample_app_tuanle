class ApplicationController < ActionController::Base
  #connect to the helper
  include SessionsHelper
  add_flash_types :info, :error, :warning, :success
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  private

  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "vui lòng đăng nhập để tiếp tục"
      redirect_to login_url, status: :see_other
    end
  end
end
