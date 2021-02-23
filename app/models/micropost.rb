class Micropost < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validates :images,
            content_type: { in: %w[image/jpeg image/png image/gif], message: 'must be a valid image format' },
            size: { less: 5.megabyte, message: 'should be less than 5MB' }

end
