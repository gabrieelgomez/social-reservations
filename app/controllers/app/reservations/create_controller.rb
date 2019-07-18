module App::Reservations
  class CreateController < ReservationsController
    # layout 'app/layouts/application'

    def build_invoice
      currency = session[:invoice].first['currency']
      @reservation.build_invoice(
        token: session[:invoice].first['token'],
        address: session[:invoice].first['address'],
        amount: @price_total,
        currency: currency,
        status: :pending
      )
    end

    def set_price_agency
      if @user.try(:has_role_agentable?)
        if @user.agency
          @agency = @user.agency
          @agent  = nil
        elsif @user.agent
          @agency = @user.agent.agency
          @agent  = @user.agent
        end
        @comission = @agency.comission_percentage
        @lending   = @agency.lending_percentage
        @price_comission = @price_total * (@comission/100)
        @price_lending   = @price_total * (@lending/100)
        @price_total_pax = @price_total
        @price_total     = @price_total - @price_comission - @price_lending
        @price_total_agency = @price_total
      else
        @price_total_pax = @price_total
      end
    end

    def find_or_create_user
      # if user not loggeding
      unless current_user
        # each params user
        @user_session = session[:user].first
        @user = User.with_deleted.find_by(email: @user_session['email'].downcase)

        # if user.nil?
        unless @user&.deleted_at.nil?
          @user.restore
          ReservationMailer.send_password(@user).deliver_now
        end

        unless @user
          password = Devise.friendly_token.first(8)
          @user = User.create(
            name: @user_session['name'],
            email: @user_session['email'],
            dni: @user_session['dni'],
            phone: @user_session['phone'],
            password: password,
            password_confirmation: password
          )
          @user.add_role :client
          @user.format_accessable_passwd(password)
          ReservationMailer.send_password(@user).deliver_now
        end

      else
        @user = current_user
      end
      @user.add_role :client
    end

    def create_travellers
      return if session[:travellers].nil?
      session[:travellers].each do |traveler|
        KepplerTravel::Traveller.create(
          name: traveler['name'],
          dni: traveler['dni'],
          reservation: @reservation
        )
      end
    end

    private
    # Only allow a trusted parameter "white list" through.
    def reservation_params
      params.require(:reservation).permit(:origin, :arrival, :origin_location, :arrival_location,
                                          :airline_origin, :airline_arrival, :flight_number_origin, :flight_number_arrival, :flight_origin, :flight_arrival, :hour_origin, :hour_arrival, :quantity_adults, :quantity_kids, :description, :quantity_kit, :round_trip, :airport_origin, :position, :deleted_at, :travellers_doc, travellers_attributes: [:name, :dni])
    end

  end
end
