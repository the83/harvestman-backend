class Instrument < ActiveRecord::Base
  validates :permalink, presence: true, length: { maximum: 30 }, uniqueness: true
  has_many :products
  validates :name, presence: true
  include PermalinkSanitizer
  before_save { sanitize_permalink! }
  mount_uploaders :images, ImageUploader
end
