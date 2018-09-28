module KepplerTravel
  class Room < ApplicationRecord
    # acts_as_paranoid

    # belongs_to :lodgment

    belongs_to :circuitable, optional: true
    has_one :destination, through: :circuitable
    has_one :lodgment, through: :circuitable
    has_one :circuit, through: :circuitable

  end
end
