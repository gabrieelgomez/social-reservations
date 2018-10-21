User.class_eval do
  has_many :reservations, class_name: 'KepplerTravel::Reservation'
  has_one :driver, class_name: 'KepplerTravel::Driver', dependent: :destroy
  accepts_nested_attributes_for :driver

  def reservations_where(type)
    self.reservations.with_deleted.select{|res| res.reservationable.class_str.downcase == type}
  end

end
