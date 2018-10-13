module KepplerTravel
  class MultidestinationableRoom < ApplicationRecord
    acts_as_paranoid
    belongs_to :multidestinationable
    belongs_to :room

    def lodgment_id
      self.multidestinationable.lodgment_id
    end

    def type_room
      self.room.type_room
    end

  end
end
