module KepplerTravel
  class Order < ApplicationRecord
    belongs_to :driver, optional: true
    belongs_to :agency, optional: true
    belongs_to :agent,  optional: true
    belongs_to :reservation

    validates_inclusion_of :status, :in => %w(pending cancelled approved)
    
  end
end
