module KepplerTravel
  # Policy for Vehicle model
  class VehiclePolicy < KepplerTravelPolicy
    attr_reader :user, :objects

    def initialize(user, objects)
      @user = user
      @objects = objects
    end
  end
end
