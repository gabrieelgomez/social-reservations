module KepplerTravel
  class Vehicleable < ApplicationRecord
    # acts_as_paranoid

    belongs_to :destination
    belongs_to :vehicle

  end
end
