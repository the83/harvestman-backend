class Post < ActiveRecord::Base
  validates :permalink, presence: true, length: { maximum: 30 }, uniqueness: true
  validates :content, presence: true
  validates :title, presence: true

  acts_as_ordered_taggable

  include PermalinkSanitizer
  before_save { sanitize_permalink! }

  mount_uploaders :images, ImageUploader
end
