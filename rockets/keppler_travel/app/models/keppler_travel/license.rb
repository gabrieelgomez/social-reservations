module KepplerTravel
  class License < ApplicationRecord
    belongs_to :car_description
    belongs_to :driver, optional: true
  end
end
