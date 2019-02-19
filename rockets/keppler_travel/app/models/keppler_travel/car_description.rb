module KepplerTravel
  class CarDescription < ApplicationRecord
    acts_as_paranoid
    
    belongs_to :driver
    belongs_to :vehicle
    has_many :licenses, inverse_of: :car_description
    accepts_nested_attributes_for :licenses, reject_if: :all_blank, allow_destroy: true
  end
end
