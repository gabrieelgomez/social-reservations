module KepplerTravel
  module Admin
    class CircuitableService

      def self.create(circuit, params)
        Ranking.all.each do |ranking|

          circuitable = Circuitable.create!(
            circuit: circuit,
            ranking: ranking,
            status: false
          )

          circuitable_room_ids = []
          Room.all.each do |room|
            cri = CircuitableRoom.create!(
              price_cop: 0,
              price_usd: 0,
              status: false,
              room: room,
              circuitable: circuitable
            )
            circuitable_room_ids.push(cri.id)
          end # Rooms end

          circuitable.update!(circuitable_room_ids: circuitable_room_ids)
        end # Rankings end

      end # Create end

    end
  end
end
