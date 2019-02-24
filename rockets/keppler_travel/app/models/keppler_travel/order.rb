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

    validates_inclusion_of :status, :in => %w(pending cancelled credit_agency payment_link approved)
    validates_inclusion_of :status_pay, :in => %w(pending cancelled approved)

    def status_pay? status
      self.status.to_sym.eql?(status)
    end

    def status_class?
      case self.status
        when 'approved'
          'btn-success'
        when 'credit_agency'
          'btn-success'
        when 'payment_link'
          'btn-success'
        when 'pending'
          'btn-warning'
        when 'cancelled'
          'btn-danger'
        else
          'btn-info'
      end
    end

    def status_pay_class?
      case self.status_pay
        when 'approved'
          'btn-success'
        when 'pending'
          'btn-warning'
        when 'cancelled'
          'btn-danger'
        else
          'btn-info'
      end
    end

  end
end
