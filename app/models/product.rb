class Product < ActiveRecord::Base
  validates :model_number, presence: true, uniqueness: true
end
