module KepplerTravel
  # Policy for Agent model
  class AgentPolicy < ControllerPolicy
    attr_reader :user, :objects

    def initialize(user, objects)
      @user = user
      @objects = objects
    end

    def update_user?
      true
    end

  end
end
