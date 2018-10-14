module KepplerTravel
  class Multidestinationable < ApplicationRecord
    acts_as_paranoid

    belongs_to :destination
    belongs_to :multidestination
    belongs_to :lodgment
    has_many   :multidestinationable_rooms
    accepts_nested_attributes_for :multidestinationable_rooms

    def price_table(square, currency)
      @table = []
      square.each{|k,v|
        next if k == 'lodgment_id'
        room = self.multidestinationable_rooms.select{|x|
          x.type_room == k
        }.first
        @table.push(
          type: room.type_room,
          price: room.try("price_#{currency}"),
          quantity: v,
          total_room: room.try("price_#{currency}") * v.to_i
        )
      }
      @table.push(total_price_table: @table.map{|room| room[:total_room]}.sum)
      @table
    end

  end
end
