module KepplerTravel
  class Invoice < ApplicationRecord
    acts_as_paranoid

    belongs_to :reservation
    validates_inclusion_of :status, :in => %w(pending cancelled credit_agency payment_link)
    validates_inclusion_of :status_pay, :in => %w(pending cancelled approved)

    validates :token, uniqueness: true

    def status_pay? status
      self.status.to_sym.eql?(status)
    end

    def status_class?

      case self.status
      when 'approved'
        'badge-success'
      when 'pending'
        'badge-warning'
      when 'cancelled'
        'badge-danger'
      else
        'badge-info'
      end

    end

  end
end
