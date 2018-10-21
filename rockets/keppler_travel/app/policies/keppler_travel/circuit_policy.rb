module KepplerTravel
  # Policy for Circuit model
  class CircuitPolicy < KepplerTravelPolicy
    attr_reader :user, :objects

    def initialize(user, objects)
      @user = user
      @objects = objects
    end

    def rooms_tables?
      true
    end

  end
end
