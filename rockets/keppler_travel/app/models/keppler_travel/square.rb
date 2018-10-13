module KepplerTravel
  class Square < ApplicationRecord
    acts_as_paranoid
    belongs_to :ranking, optional: true
    belongs_to :lodgment, optional: true
    belongs_to :reservation
    belongs_to :squareable, -> { with_deleted }, polymorphic: true
  end
end
