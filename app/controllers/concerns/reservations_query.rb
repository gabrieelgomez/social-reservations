module ReservationsQuery
  extend ActiveSupport::Concern

  private
  # Set by Step 1
  def set_reservationable
    @render = params[:reservationable_type].downcase.pluralize
    case params[:reservationable_type]
      when 'vehicle'
        @vehicle      = @KT::Vehicle.find params[:reservationable_id]
        @kit_quantity = @vehicle.kit['quantity']
        @price_total  = @round_trip == 'true' ? @vehicle.set_price_destination(@locality, @currency).to_f*2 : @vehicle.set_price_destination(@locality, @currency).to_f
        set_price_agency
      when 'tour'
        @tour = @KT::Tour.find params[:reservationable_id]
        set_price_tour
      when 'circuit'
        @circuit = @KT::Circuit.find params[:reservationable_id]
        @rankings = @circuit.circuitable_rooms.as_json(
          methods: %i[ranking_id type_room]
        )
      when 'multidestination'
        @multidestination = @KT::Multidestination.find params[:reservationable_id]
        @lodgments = @multidestination.multidestinationable_rooms.as_json(
          methods: %i[lodgment_id type_room]
        )
    end
  end

  # Set by Step 1
  def set_price_tour
    @total_adults    = @tour.price_adults[@currency].to_f * @adults.to_f
    @total_kids      = @tour.calculate_kids(@kids, @currency).to_f * @kids.to_f
    @price_total     = @total_adults + @total_kids
  end

  # Set by Step 2 Vehicle
  def set_vehicle_checkout
    @render          = 'vehicles'
    @locality        = [@reservationable['origin_locality'], @reservationable['arrival_locality']]
    @reservationable = @KT::Vehicle.find(@reservationable['id'])
    @multiple        = @KT::Reservation.multiple(@reservation)
    @round_trip      = session[:reservation]['round_trip']
    @vehicle         = @reservationable
    @price_total     = @round_trip == 'true' ? @vehicle.set_price_destination(@locality, @currency).to_f*2 : @vehicle.set_price_destination(@locality, @currency).to_f
    set_price_agency
  end

  # Set by Step 2 Tour
  def set_tour_checkout
    @render          = 'tours'
    @reservationable = @KT::Tour.find(@reservationable['id'])
  end

  # Set by Step 2 Circuit
  def set_circuit_checkout
    @render          = 'circuits'
    @reservationable = @KT::Circuit.find(@reservationable['id'])
  end

  # Set by Step 2 Multidestination
  def set_multidestination_checkout
    @render          = 'multidestinations'
    @reservationable = @KT::Multidestination.find(@reservationable['id'])
  end

  def set_price_agency
    if current_user.try(:has_role?, :agency)
      @agency    = current_user.agency
      @comission = @agency.comission_percentage
      @lending   = @agency.lending_percentage
      @price_comission = @price_total * (@comission/100)
      @price_lending   = @price_total * (@lending/100)
      @price_total_agency = @price_total - @price_comission - @price_lending
    end
  end

end
