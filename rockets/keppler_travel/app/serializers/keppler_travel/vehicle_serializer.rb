class KepplerTravel::VehicleSerializer < ActiveModel::Serializer
  attributes :id, :cover, :title, :description, :includes, :conditions, :files,
             :kit, :seat, :date, :time, :inner_price, :outer_price, :position,
             :status, :deleted_at, :created_at, :updated_at, :price_destination
  # attributes *KepplerTravel::Vehicle.column_names

  def price_destination
    locality = @instance_options[:locality]
    self.object.set_price_destination(locality, 'usd')
  end

end
