class Post < ActiveRecord::Base
  validates :permalink, presence: true, length: { maximum: 30 }, uniqueness: true
  validates :content, presence: true
  validates :title, presence: true
  include PermalinkSanitizer
  before_save { sanitize_permalink! }
end
