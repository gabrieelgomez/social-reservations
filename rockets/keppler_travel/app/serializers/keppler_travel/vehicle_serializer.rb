class KepplerTravel::VehicleSerializer < ActiveModel::Serializer
  attributes :id, :cover, :title, :description, :includes, :conditions, :files,
             :kit, :seat, :date, :time, :inner_price, :outer_price, :position,
             :status, :deleted_at, :created_at, :updated_at, :price_destination, :currency, :cotization
  # attributes *KepplerTravel::Vehicle.column_names

  def price_destination
    locality = @instance_options[:locality]
    currency = @instance_options[:currency]
    self.object.set_price_destination(locality, currency)
  end

  def currency
    @instance_options[:currency]
  end

  def cotization
    @instance_options[:cotization]
  end

end
