module Api
  # ApiController -> Controller out the back-office
  class ApiController < ::ApplicationController
    # skip_before_action :verify_authenticity_token
    # authenticate_user!, except: [:suggestions]
    respond_to :json

    def get_reservation
      @result = {
        reservation_id: KepplerTravel::Reservation.with_deleted.last.try(:id).to_i + 1,
        invoice: SecureRandom.hex(4).upcase
      }
      render json: { data: @result, status: 200, success: true }
    end

  end
end
