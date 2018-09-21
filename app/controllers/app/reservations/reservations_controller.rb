module App::Reservations
  class ReservationsController < FrontController
    # layout 'app/layouts/application'
    before_action :set_reservationable, only: :reservations

    # Step 1
    def reservations
      @reservation = KepplerTravel::Reservation.new
      @adults      = params[:adults]
      @kids        = params[:kids]
      @seats       = @adults.to_i + @kids.to_i
    end

    # Step 2
    def checkout
      @reservation     = session[:reservation]
      @travellers      = session[:travellers].try(:first)
      @user            = session[:user].try(:first) || current_user
      @invoice         = session[:invoice].try(:first)
      @reservationable = session[:reservationable]

      # -----
      case @reservationable['type']
        when 'vehicle'
          @render          = 'vehicles'
          @reservationable = KepplerTravel::Vehicle.find(@reservationable['id'])
          @multiple        = @reservation['round_trip'] == 'true' ? '2' : '1'
          @price_total     = @reservation['round_trip'] == 'true' ? @reservationable['price'][@currency].to_f*2 : @reservationable['price'][@currency].to_f
        when 'tour'
          @render          = 'tours'
          @reservationable = KepplerTravel::Tour.find(@reservationable['id'])
        when 'circuits'
          nil
        when 'multidestinations'
          nil
      end
      # -----

    end

    # Step 3
    def transaction_payment
      @reservation         = KepplerTravel::Reservation.find params[:reservation_id]
      @invoice             = @reservation.invoice
      @user                = @reservation.user
      @reservationable     = @reservation.reservationable
      redirect_to root_path if @invoice.status_pay? :approved
    end

    # Step 4
    def invoice
      byebug
    end

    private

    def set_reservationable
      @render = params[:reservationable_type].downcase.pluralize
      case params[:reservationable_type]
        when 'vehicle'
          @vehicle      = KepplerTravel::Vehicle.find params[:reservationable_id]
          @kit_quantity = @vehicle.kit['quantity']
        when 'tour'
          @tour = KepplerTravel::Tour.find params[:reservationable_id]
        when 'circuits'
          nil
        when 'multidestinations'
          nil
      end
    end


  end
end
