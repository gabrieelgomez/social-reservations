module KepplerTravel
  class Multidestinationable < ApplicationRecord
    acts_as_paranoid

    belongs_to :destination
    belongs_to :multidestination
    belongs_to :lodgment
    has_many   :multidestinationable_rooms
    accepts_nested_attributes_for :multidestinationable_rooms

  end
end
