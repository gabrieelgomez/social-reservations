module KepplerContactus
  # Policy for Message model
  class MessagePolicy < KepplerContactusPolicy
    attr_reader :user, :objects

    def initialize(user, objects)
      @user = user
      @objects = objects
    end
  end
end
