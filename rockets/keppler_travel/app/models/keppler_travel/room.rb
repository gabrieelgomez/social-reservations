module KepplerTravel
  class Room < ApplicationRecord
    acts_as_paranoid
    
    belongs_to :lodgment
  end
end
