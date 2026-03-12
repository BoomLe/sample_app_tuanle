class Micropost < ApplicationRecord
  belongs_to :user

  #add image
  has_one_attached :image do |attachable|
    attachable.variant :display, resize_to_limit: [500, 500]
  end

  # sort desc => content
  default_scope -> { order(created_at: :desc) }
  # check id user
  validates :user_id, presence: true

  # check the content
  validates :content, presence: true, length: { maximum: 140 }
  validates :image, content_type: { in: %w[image/jpeg image/gif image/png], message: "must be a valid image format" },
                    size: { less_than: 5.megabytes, message: "should be less than 5MB" }
end
