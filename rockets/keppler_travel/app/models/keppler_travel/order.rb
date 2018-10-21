module KepplerTravel
  class Order < ApplicationRecord
    belongs_to :driver
    belongs_to :reservation
  end
end
