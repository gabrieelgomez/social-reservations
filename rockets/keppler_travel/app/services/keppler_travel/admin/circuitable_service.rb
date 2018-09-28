module KepplerTravel
  module Admin
    class CircuitableService

      def self.create(circuit, params)
        destination_ids = params[:circuit][:destination_ids].split(',').map(&:to_i)
        destinations = Destination.where(id: destination_ids)
        destinations.each do |destination|
          destination.lodgments.each do |lodgment|

            circuitable = Circuitable.create!(
              destination: destination,
              circuit: circuit,
              lodgment: lodgment,
              status: false
            )

            circuitable_room_ids = []
            Room.all.each do |room|
              cri = CircuitableRoom.create!(
                price: {
                  cop: '0',
                  usd: '0'
                },
                status: false,
                room: room,
                circuitable: circuitable
              )
              circuitable_room_ids.push(cri.id)
            end # Rooms end

            circuitable.update!(circuitable_room_ids: circuitable_room_ids)
          end# Lodgments end
        end # Destination end

      end

    end
  end
end
