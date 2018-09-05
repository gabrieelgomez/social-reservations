module KepplerTravel
  # Policy for Vehicle model
  class VehiclePolicy < ControllerPolicy
    attr_reader :user, :objects

    def initialize(user, objects)
      @user = user
      @objects = objects
    end
  end
end
