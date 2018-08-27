module KepplerTravel
  # Policy for Transfer model
  class TransferPolicy < ControllerPolicy
    attr_reader :user, :objects

    def initialize(user, objects)
      @user = user
      @objects = objects
    end
  end
end
