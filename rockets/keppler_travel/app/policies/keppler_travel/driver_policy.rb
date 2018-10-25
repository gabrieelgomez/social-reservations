module KepplerTravel
  # Policy for Driver model
  class DriverPolicy < KepplerTravelPolicy
    attr_reader :user, :objects

    def initialize(user, objects)
      @user = user
      @objects = objects
    end

    def update_user?
      true
    end

    def description_tables?
      true
    end

  end
end
