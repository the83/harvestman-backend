class Post < ActiveRecord::Base
  validates :permalink, presence: true, length: { maximum: 30 }, uniqueness: true
  validates :content, presence: true
  validates :title, presence: true

  acts_as_ordered_taggable

  has_many :images, :as => :imageable
  accepts_nested_attributes_for :images, :allow_destroy => :true

  include PermalinkSanitizer
  before_save { sanitize_permalink! }
end
