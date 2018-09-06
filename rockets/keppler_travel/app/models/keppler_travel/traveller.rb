module KepplerTravel
  class Traveller < ApplicationRecord
    belongs_to :reservation
  end
end
