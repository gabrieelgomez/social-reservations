module KepplerTravel
  module Admin
    class MultidestinationableService

      def self.create(multidestination, params = nil, destination_ids=nil)
        destination_ids = params[:multidestination][:destination_ids].split(',').map(&:to_i) unless params.nil?
        destinations = Destination.where(id: destination_ids)
        destinations.each do |destination|
          destination.lodgments.each do |lodgment|

            multidestinationable = Multidestinationable.create!(
              destination: destination,
              multidestination: multidestination,
              lodgment: lodgment,
              status: false
            )

            multidestinationable_room_ids = []
            Room.all.each do |room|
              cri = MultidestinationableRoom.create!(
                price_cop: 0,
                price_usd: 0,
                status: false,
                room: room,
                multidestinationable: multidestinationable
              )
              multidestinationable_room_ids.push(cri.id)
            end # Rooms end

            multidestinationable.update!(multidestinationable_room_ids: multidestinationable_room_ids)
          end # Lodgments end
        end # Destination end

      end # Create end

      def self.update_multidestinationable(multidestination)
        lodgments = multidestination.destinations.map(&:lodgment_ids).flatten
        lodgments_multidestinationables = multidestination.multidestinationables.map(&:lodgment_id)
        ids = lodgments - lodgments_multidestinationables
        unless ids.empty?
          ids.each do |id|
            destination = Destination.all.select{|dest| dest.lodgment_ids.include?(id)}.first
            multidestinationable = Multidestinationable.create!(
              destination: destination,
              multidestination: multidestination,
              lodgment_id: id,
              status: false
            )
            multidestinationable_room_ids = []
            Room.all.each do |room|
              cri = MultidestinationableRoom.create!(
                price_cop: 0,
                price_usd: 0,
                status: false,
                room: room,
                multidestinationable: multidestinationable
              )
              multidestinationable_room_ids.push(cri.id)
            end # Rooms end
          end # Ids end
        end # Unless end

      end # Update end

    end
  end
end
