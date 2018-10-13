module KepplerTravel
  class Room < ApplicationRecord
    acts_as_paranoid
    # belongs_to :lodgment

    # Multidestination
    belongs_to :multidestinationable, optional: true
    has_one :destination, through: :multidestinationable
    has_one :lodgment, through: :multidestinationable
    has_one :multidestination, through: :multidestinationable

    # Circuits
    belongs_to :circuitable, optional: true
    has_one :ranking, through: :circuitable
    has_one :circuit, through: :circuitable

  end
end
