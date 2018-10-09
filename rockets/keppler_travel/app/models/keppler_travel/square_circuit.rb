module KepplerTravel
  class SquareCircuit < ApplicationRecord
    acts_as_paranoid
    belongs_to :lodgment, optional: true
    belongs_to :reservation
  end
end
