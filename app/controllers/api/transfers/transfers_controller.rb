module Api
  module Transfers
    class TransfersController < ApiController
      respond_to :json
      before_action :set_user, only: %[get_orders]

      def get_orders
        @reservations = @user.reservations_where('vehicle').sort.reverse.as_json(only: %i[id origin arrival origin_location arrival_location flight_origin flight_arrival quantity_adults quantity_kids round_trip status], methods: [:pay_to], include: [:order, :invoice])
        render json: { data: @reservations, status: 200, success: @success }
      end

      def build_invoice
        @reservation.build_invoice(
          token: params[:reservationable][:token],
          address: @reservation.description,
          amount: @price_total,
          currency: @currency,
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
        @user = User.with_deleted.find_by(email: params[:user][:email].downcase)

        if @user.nil?
          password = Devise.friendly_token.first(8)
          @user = User.create(
            name: params[:user][:name],
            email: params[:user][:email],
            dni: params[:user][:dni],
            phone: params[:user][:phone],
            password: password,
            password_confirmation: password
          )
          @user.add_role :client
          @user.format_accessable_passwd(password)
          ReservationMailer.send_password(@user).deliver_now
        end

        unless @user&.deleted_at.nil?
          @user.restore
          ReservationMailer.send_password(@user).deliver_now
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

      def set_user
        @user = User.find_by(email: params[:user])
      end

    end
  end
end
