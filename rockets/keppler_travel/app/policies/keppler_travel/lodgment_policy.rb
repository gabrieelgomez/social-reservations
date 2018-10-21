module KepplerTravel
  # Policy for Lodgment model
  class LodgmentPolicy < KepplerTravelPolicy
    attr_reader :user, :objects

    def initialize(user, objects)
      @user = user
      @objects = objects
    end
  end
end
