module KepplerTravel
  class CircuitableRoom < ApplicationRecord
    acts_as_paranoid
    belongs_to :circuitable
    belongs_to :room

    def lodgment_id
      self.circuitable.lodgment_id
    end

    def type_room
      self.room.type_room
    end

  end
end
