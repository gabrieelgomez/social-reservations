module KepplerTravel
  class CircuitableRoom < ApplicationRecord
    acts_as_paranoid
    belongs_to :circuitable
    belongs_to :room
  end
end
