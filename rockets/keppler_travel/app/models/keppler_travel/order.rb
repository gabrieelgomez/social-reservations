module KepplerTravel
  class Order < ApplicationRecord
    acts_as_paranoid

    belongs_to :driver, optional: true
    belongs_to :agency, optional: true
    belongs_to :agent,  optional: true
    belongs_to :reservation

    # position_status
    # 1 = pending
    # 2 = cancelled
    # 3 = credit_agency
    # 4 = payment_link

    validates_inclusion_of :status, :in => %w(pending cancelled credit_agency payment_link)
    validates_inclusion_of :status_pay, :in => %w(pending approved)
  end
end
