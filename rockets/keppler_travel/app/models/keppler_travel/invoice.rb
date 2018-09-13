module KepplerTravel
  class Invoice < ApplicationRecord
    belongs_to :reservation

    def status_pay? status
      self.status.to_sym.eql?(status)
    end

  end
end
