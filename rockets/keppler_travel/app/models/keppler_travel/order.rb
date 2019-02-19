module KepplerTravel
  class Order < ApplicationRecord
    acts_as_paranoid
    
    belongs_to :driver, optional: true
    belongs_to :agency, optional: true
    belongs_to :agent,  optional: true
    belongs_to :reservation

    validates_inclusion_of :status, :in => %w(pending cancelled approved)

  end
end
