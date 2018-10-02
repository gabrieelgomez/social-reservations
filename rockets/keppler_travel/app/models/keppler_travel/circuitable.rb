module KepplerTravel
  class Circuitable < ApplicationRecord
    acts_as_paranoid

    belongs_to :destination
    belongs_to :circuit
    belongs_to :lodgment
    has_many   :circuitable_rooms

  end
end
