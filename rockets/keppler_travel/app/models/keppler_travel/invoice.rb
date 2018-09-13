module KepplerTravel
  class Invoice < ApplicationRecord
    belongs_to :reservation

    def status_pay? status
      self.status.to_sym.eql?(status)
    end

    def status_class?

      case self.status
      when 'approved'
        'label-success'
      when 'pending'
        'label-warning'
      when 'cancelled'
        'label-danger'
      else
        'label-info'
      end

    end

  end
end
