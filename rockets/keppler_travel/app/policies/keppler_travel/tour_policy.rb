module KepplerTravel
  # Policy for Tour model
  class TourPolicy < ControllerPolicy
    attr_reader :user, :objects

    def initialize(user, objects)
      @user = user
      @objects = objects
    end
  end
end
