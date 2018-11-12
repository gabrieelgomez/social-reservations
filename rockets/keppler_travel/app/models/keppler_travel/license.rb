module KepplerTravel
  class License < ApplicationRecord
    belongs_to :car_description
  end
end
