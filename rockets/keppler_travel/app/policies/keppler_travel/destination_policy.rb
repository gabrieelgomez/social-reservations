module KepplerTravel
  # Policy for Destination model
  class DestinationPolicy < KepplerTravelPolicy
    attr_reader :user, :objects

    def initialize(user, objects)
      @user = user
      @objects = objects
    end
  end
end
