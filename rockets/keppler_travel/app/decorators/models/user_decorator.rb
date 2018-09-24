User.class_eval do
  has_many :reservations, class_name: 'KepplerTravel::Reservation'

  def reservations_where(type)
    self.reservations.with_deleted.select{|res| res.reservationable.class_str.downcase == type}
  end

end
