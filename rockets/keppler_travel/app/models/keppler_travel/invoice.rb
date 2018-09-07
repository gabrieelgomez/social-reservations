module KepplerTravel
  class Invoice < ApplicationRecord
    belongs_to :reservation
  end
end
