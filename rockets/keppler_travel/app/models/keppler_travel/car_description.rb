module KepplerTravel
  class CarDescription < ApplicationRecord
    belongs_to :driver
    belongs_to :vehicle
  end
end
