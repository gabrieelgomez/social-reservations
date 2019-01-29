User.class_eval do
  has_many :reservations, class_name: 'KepplerTravel::Reservation'
  has_one :driver, class_name: 'KepplerTravel::Driver', dependent: :destroy
  has_one :agency, class_name: 'KepplerTravel::Agency', dependent: :destroy
  has_one :agent, class_name: 'KepplerTravel::Agent', dependent: :destroy

  accepts_nested_attributes_for :driver
  accepts_nested_attributes_for :agency
  accepts_nested_attributes_for :agent


  def reservations_where(type)
    self.reservations.with_deleted.select{|res| res.reservationable.class_str.downcase == type}
  end

end
