module Api::Transfers
  class ReservationsController < GeneralController

    def create_reservation
       @reservation = KepplerTravel::Reservation.new(params[:reservation].permit!)
       find_or_create_user
       @reservation.status = :pending
       @reservation.user = @user
       # @reservation.document = KepplerTravel::Document.find session[:reservationable]['document_id']
       @reservation.reservationable = KepplerTravel::Vehicle.find_by id: params[:reservationable][:vehicle_id]
       @currency = params[:reservationable][:currency]
       set_price
       build_invoice
       @reservation.build_order(
         details: 'user',
         status: 'pending',
         price_reservationable: @price_reservationable,
         price_total_pax: @price_total_pax,
         user_referer: @user.email
       )
       if @reservation.save!
         # create_travellers
         if current_user.try(:has_role_agentable?)
           @reservation.order.update(
             details: 'agency',
             agency: @agency,
             agent: @agent,
             comission: @comission,
             lending: @lending,
             price_comission: @price_comission,
             price_lending: @price_lending,
             price_total_agency: @price_total_agency,
             agency_referer: @agency.id,
             agent_referer: @agent&.id
           )
           ReservationMailer.transfer_status(@reservation, @user).deliver_now
           @success = true
         elsif @price_total.zero?
           ReservationMailer.transfer_status(@reservation, @user).deliver_now
           @success = true
         else
           ReservationMailer.transfer_status(@reservation, @user).deliver_now
           @success = true
         end
       else
         @success = false
       end

      render json: { data: @reservation.as_json(include: %i[invoice order]), status: 200, success: @success }
    end


    private

    def set_price
      @price = params[:reservationable][:price_destination]
      if @user.is_from_colombia?
        @cotization  = true
        @price_total = 0
      else
        @price_reservationable   = @price.to_f
        @price_total             = @reservation.round_trip == 'true' ? @price_reservationable * 2 : @price_reservationable
        @price_total_pax         = @price_total
      end

      set_price_agency
    end

    # Only allow a trusted parameter "white list" through.
    def reservation_params
      params.require(:reservation).permit(:origin, :arrival, :origin_location, :arrival_location,
                                          :airline_origin, :airline_arrival, :flight_number_origin, :flight_number_arrival, :flight_origin, :flight_arrival, :hour_origin, :hour_arrival, :quantity_adults, :quantity_kids, :description, :quantity_kit, :round_trip, :airport_origin, :position, :deleted_at, :travellers_doc, travellers_attributes: [:name, :dni])
    end

  end
end
