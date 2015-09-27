class Product < ActiveRecord::Base
  belongs_to :instrument
  validates :model_number, presence: true, uniqueness: true
  acts_as_ordered_taggable
  has_many :images, :as => :imageable
end
