module UsersHelper

  # Trả về ảnh Gravatar cho người dùng được truyền vào
  def gravatar_for(user)
    # 1. Ép email về chữ thường và "băm" nó ra bằng thuật toán MD5
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)

    # 2. Gắn cục email đã băm vào đường dẫn của Gravatar
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"

    # 3. Trả về thẻ <img> chứa bức ảnh đó
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end
end
