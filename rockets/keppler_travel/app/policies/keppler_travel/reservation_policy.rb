module KepplerTravel
  # Policy for Reservation model
  class ReservationPolicy < KepplerTravelPolicy
    attr_reader :user, :objects

    def initialize(user, objects)
      @user = user
      @objects = objects
    end

    def assignment?
      true
    end

    def unassign?
      true
    end

  end
end
