module KepplerContactus
  # Policy for Board model
  class KepplerContactusPolicy < ControllerPolicy
    attr_reader :user, :objects

    def initialize(user, objects)
      @user = user
      @objects = objects
    end

    def keppler_admin?
      user.keppler_admin? || user.admin?
    end

    def admin?
      true
    end

  end
end
