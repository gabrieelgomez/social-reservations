module KepplerTravel
  class Multidestinationable < ApplicationRecord
    acts_as_paranoid

    belongs_to :destination
    belongs_to :multidestination
    belongs_to :lodgment
    has_many   :multidestinationable_rooms
    accepts_nested_attributes_for :multidestinationable_rooms

    def price_table(square, currency, adults)
      pricing_table = []
      square.each{|k,v|
        next if k == 'lodgment_id'
        room = self.multidestinationable_rooms.select{|x|
          x.type_room == k
        }.first
        pricing_table.push(
          type: room.type_room,
          price: room.try("price_#{currency}"),
          quantity: v,
          total_room: room.try("price_#{currency}") * v.to_i
        )
      }
      total_kids_per  = pricing_table.last[:total_room]
      total_rooms_per = (pricing_table.map{|room| room[:total_room] }.sum - total_kids_per) * adults

      total_price_table = total_rooms_per + total_kids_per
      @table = {
        metadata: multidestination.as_json(only: %i[id title subtitle banner status featured]),
        pricing_table: pricing_table,
        total_kids_per: total_kids_per,
        total_rooms_per: total_rooms_per,
        total_price_table: total_price_table
      }
    end

  end
end
