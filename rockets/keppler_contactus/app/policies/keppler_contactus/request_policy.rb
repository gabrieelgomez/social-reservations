module KepplerContactus
  # Policy for Request model
  class RequestPolicy < KepplerContactusPolicy
    attr_reader :user, :objects

    def initialize(user, objects)
      @user = user
      @objects = objects
    end
  end
end
