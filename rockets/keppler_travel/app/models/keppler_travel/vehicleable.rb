module KepplerTravel
  class Vehicleable < ApplicationRecord
    acts_as_paranoid

    belongs_to :destination
    belongs_to :vehicle

    scope :search_destination, -> (str) do
      ransack(title_cont: str[0]).result.first || ransack(title_cont: str[1]).result.first
    end

  end
end
