module KepplerTravel
  # Policy for Board model
  class KepplerTravelPolicy < ControllerPolicy
    attr_reader :user, :objects

    def initialize(user, objects)
      @user = user
      @objects = objects
    end

    def bulk_upload?
      true
    end

    def bulk_upload_save?
      true
    end

  end
end
