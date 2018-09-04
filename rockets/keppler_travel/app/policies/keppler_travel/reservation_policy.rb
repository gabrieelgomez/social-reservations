module KepplerTravel
  # Policy for Reservation model
  class ReservationPolicy < ControllerPolicy
    attr_reader :user, :objects

    def initialize(user, objects)
      @user = user
      @objects = objects
    end
  end
end
