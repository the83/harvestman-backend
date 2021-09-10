class Product < ActiveRecord::Base
  belongs_to :instrument
  validates :model_number, presence: true, uniqueness: true
  acts_as_ordered_taggable

  has_many :images, -> { order(created_at: :asc) }, :as => :imageable
  accepts_nested_attributes_for :images, :allow_destroy => :true

  has_many :firmwares, -> { order(created_at: :asc) }
  accepts_nested_attributes_for :firmwares, :allow_destroy => :true

  has_many :manuals, -> { order(created_at: :asc) }
  accepts_nested_attributes_for :manuals, :allow_destroy => :true
end
