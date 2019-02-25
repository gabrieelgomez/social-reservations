module ReservationsQuery
  extend ActiveSupport::Concern

  private
  # Set by Step 1
  def set_reservationable
    @render = params[:reservationable_type].downcase.pluralize
    case params[:reservationable_type]
      when 'vehicle'
        @vehicle      = @KT::Vehicle.find params[:reservationable_id]
        set_price_vehicle
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

  def set_price_vehicle
    @kit_quantity = @vehicle.kit['quantity']
    @price_total  = @round_trip == 'true' ? @vehicle.set_price_destination(@locality, @currency).to_f*2 : @vehicle.set_price_destination(@locality, @currency).to_f
    set_price_agency
  end

  def set_price_tour
    @total_adults    = @tour.price_adults[@currency].to_f * @adults.to_f
    @total_kids      = @tour.calculate_kids(@currency).to_f * @kids.to_f
    @price_total     = @total_adults + @total_kids
    set_price_agency
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
    @adults          = session[:reservation]['quantity_adults']
    @kids            = session[:reservation]['quantity_kids']
    @seats           = @adults.to_i + @kids.to_i
    @total_adults    = @reservationable.price_adults[@currency].to_f * @adults
    @total_kids      = @reservationable.calculate_kids(@currency).to_f * @kids
    @price_total     = @total_adults + @total_kids
    set_price_agency
  end

  # Set by Step 2 Circuit
  def set_circuit_checkout
    @render                = 'circuits'
    @reservationable       = @KT::Circuit.find(@reservationable['id'])
    @square                = session[:square_circuit]
    @circuitable           = @reservationable.circuitables.find_by(ranking_id: @square['ranking_id'])
    @table_reservationable = session[:table_reservationable] = @circuitable.price_table(@square, @currency)
  end

  # Set by Step 2 Multidestination
  def set_multidestination_checkout
    @render          = 'multidestinations'
    @reservationable = @KT::Multidestination.find(@reservationable['id'])
    @square = session[:square_multidestination]
    @multidestinationable = @reservationable.multidestinationables.find_by(lodgment_id: @square['lodgment_id'])
    @table_reservationable = session[:table_reservationable] = @multidestinationable.price_table(@square, @currency, @reservation['quantity_adults'])
  end

  def set_price_agency
    if current_user.try(:has_role_agentable?)
      if current_user.agency
        @agency = current_user.agency
        @agent  = nil
      elsif current_user.agent
        @agency = current_user.agent.agency
        @agent  = current_user.agent
      end
      @comission = @agency.comission_percentage
      @lending   = @agency.lending_percentage
      @price_comission = @price_total * (@comission/100)
      @price_lending   = @price_total * (@lending/100)
      @price_total_agency = @price_total - @price_comission - @price_lending
    end
  end

end
