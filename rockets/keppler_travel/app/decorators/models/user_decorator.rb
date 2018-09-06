# byebug
User.class_eval do
  has_many :reservations, class_name: 'KepplerTravel::Reservation'
end
