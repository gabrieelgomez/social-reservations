module KepplerTravel
  class Traveller < ApplicationRecord
    acts_as_paranoid
    
    belongs_to :reservation
  end
end
