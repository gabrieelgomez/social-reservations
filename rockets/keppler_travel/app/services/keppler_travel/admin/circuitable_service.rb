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
                price_cop: 0,
                price_usd: 0,
                status: false,
                room: room,
                circuitable: circuitable
              )
              circuitable_room_ids.push(cri.id)
            end # Rooms end

            circuitable.update!(circuitable_room_ids: circuitable_room_ids)
          end # Lodgments end
        end # Destination end

      end # Create end

      def self.update_circuitable(circuit)
        lodgments = circuit.destinations.map(&:lodgment_ids).flatten
        lodgments_circuitables = circuit.circuitables.map(&:lodgment_id)
        ids = lodgments - lodgments_circuitables
        unless ids.empty?
          ids.each do |id|
            destination = Destination.all.select{|dest| dest.lodgment_ids.include?(id)}.first
            circuitable = Circuitable.create!(
              destination: destination,
              circuit: circuit,
              lodgment_id: id,
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
          end # Ids end
        end # Unless end

      end # Update end

    end
  end
end
