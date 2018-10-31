module KepplerTravel
  module Admin
    class VehicleableService

      def self.create(vehicle, params)
        destination_ids = params[:vehicle][:destination_ids].split(',').map(&:to_i)
        destinations = Destination.where(id: destination_ids)
        destinations.each do |destination|
          vehicleable = Vehicleable.create!(
            title: destination.title,
            destination: destination,
            vehicle: vehicle
          )
        end # Destination end

      end # Create end

      def self.update_vehicleable(vehicle)
        destinations = vehicle.destination_ids
        destinations_vehicleables = vehicle.vehicleables.map(&:destination_id).map(&:to_i)
        ids = destinations - destinations_vehicleables
        unless ids.empty?
          ids.each do |id|
            destination = Destination.find(id)
            vehicleable = Vehicleable.create!(
              title: destination.title,
              destination: destination,
              vehicle: vehicle
            )
          end # Ids end
        end # Unless end

      end # Update end

    end
  end
end
