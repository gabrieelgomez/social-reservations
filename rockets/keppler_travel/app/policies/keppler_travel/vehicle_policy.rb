module KepplerTravel
  # Policy for Vehicle model
  class VehiclePolicy < KepplerTravelPolicy
    attr_reader :user, :objects

    def initialize(user, objects)
      @user = user
      @objects = objects
    end

    def prices_tables?
      true
    end

  end
end
