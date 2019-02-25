module KepplerTravel
  class Circuitable < ApplicationRecord
    acts_as_paranoid

    belongs_to :circuit
    belongs_to :ranking
    has_many :circuitable_rooms

    accepts_nested_attributes_for :circuitable_rooms

    def price_table(square, currency)
      pricing_table = []
      square.each{|k,v|
        next if k == 'ranking_id'
        room = self.circuitable_rooms.select{|x|
          x.type_room == k
        }.first
        pricing_table.push(
          type: room.type_room,
          price: room.try("price_#{currency}"),
          quantity: v,
          total_room: room.try("price_#{currency}") * v.to_i
        )
      }
      total_price_table = pricing_table.map{|room| room[:total_room]}.sum
      @table = {
        metadata: circuit.as_json(only: %i[id title subtitle banner status featured]),
        pricing_table: pricing_table,
        total_price_table: total_price_table
      }
    end

  end
end
