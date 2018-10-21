module KepplerTravel
  # Policy for Board model
  class KepplerTravelPolicy < ControllerPolicy
    attr_reader :user, :objects

    def initialize(user, objects)
      @user = user
      @objects = objects
    end

  end
end
