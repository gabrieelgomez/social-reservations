module KepplerTravel
  # Policy for Ranking model
  class RankingPolicy < KepplerTravelPolicy
    attr_reader :user, :objects

    def initialize(user, objects)
      @user = user
      @objects = objects
    end
  end
end
