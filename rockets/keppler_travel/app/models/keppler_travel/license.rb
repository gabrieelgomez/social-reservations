module KepplerTravel
  class License < ApplicationRecord
    acts_as_paranoid
    
    belongs_to :car_description
  end
end
