class Product < ActiveRecord::Base
  belongs_to :instrument
  validates :model_number, presence: true, uniqueness: true
end
