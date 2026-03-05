module UsersHelper

  # Sửa dòng khai báo để nhận thêm tham số options
  def gravatar_for(user, options = { size: 80 })
    size = options[:size]
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end
end
