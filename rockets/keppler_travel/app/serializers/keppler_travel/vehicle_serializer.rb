class KepplerTravel::VehicleSerializer < ActiveModel::Serializer
  # attributes :id, :title, :subareas
  attributes *KepplerTravel::Vehicle.column_names
end
