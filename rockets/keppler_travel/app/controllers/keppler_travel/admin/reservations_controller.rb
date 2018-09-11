require_dependency "keppler_travel/application_controller"
module KepplerTravel
  module Admin
    # ReservationsController
    class ReservationsController < ApplicationController
      layout 'keppler_travel/admin/layouts/application', except: [:new]
      before_action :authenticate_user!, except: [:create]
      before_action :set_reservation, only: [:show, :edit, :update, :destroy]
      before_action :show_history, only: [:index]
      before_action :set_attachments
      before_action :authorization
      include KepplerTravel::Concerns::Commons
      include KepplerTravel::Concerns::History
      include KepplerTravel::Concerns::DestroyMultiple
      include ObjectQuery


      # GET /reservations
      def index
        @q = Reservation.ransack(params[:q])
        reservations = @q.result(distinct: true)
        @objects = reservations.page(@current_page).order(id: :desc)
        @total = reservations.size
        @reservations = @objects.all
        if !@objects.first_page? && @objects.size.zero?
          redirect_to reservations_path(page: @current_page.to_i.pred, search: @query)
        end
        respond_to_formats(@reservations)
      end

      # GET /reservations/1
      def show
      end

      # GET /reservations/new
      def new
        @reservation = Reservation.new
      end

      # GET /reservations/1/edit
      def edit
      end

      # POST /reservations
      def create
        @reservation = Reservation.new(reservation_params)
        if @reservation.save
          redirect(@reservation, params)
          # redirect_to main_app.root_path
        else
          render :new
        end
      end

      # PATCH/PUT /reservations/1
      def update
        if @reservation.update(reservation_params)
          redirect(@reservation, params)
        else
          render :edit
        end
      end

      def clone
        @reservation = Reservation.clone_record params[:reservation_id]

        if @reservation.save
          redirect(@reservation, params)
        else
          render :new
        end
      end

      # DELETE /reservations/1
      def destroy
        @reservation.destroy
        redirect_to admin_travel_reservations_path, notice: actions_messages(@reservation)
      end

      def destroy_multiple
        Reservation.destroy redefine_ids(params[:multiple_ids])
        redirect_to(
          admin_travel_reservations_path(page: @current_page, search: @query),
          notice: actions_messages(Reservation.new)
        )
      end

      def upload
        Reservation.upload(params[:file])
        redirect_to(
          admin_reservations_path(page: @current_page, search: @query),
          notice: actions_messages(Reservation.new)
        )
      end

      def download
        @reservations = Reservation.all
        respond_to do |format|
          format.html
          format.xls { send_data(@reservations.to_xls) }
          format.json { render json: @reservations }
        end
      end

      def reload
        @q = Reservation.ransack(params[:q])
        reservations = @q.result(distinct: true)
        @objects = reservations.page(@current_page).order(position: :desc)
      end

      def sort
        Reservation.sorter(params[:row])
        @q = Reservation.ransack(params[:q])
        reservations = @q.result(distinct: true)
        @objects = reservations.page(@current_page)
        render :index
      end

      private

      def authorization
        authorize Reservation
      end

      def set_attachments
        @attachments = ['logo', 'brand', 'photo', 'avatar', 'cover', 'image',
                        'picture', 'banner', 'attachment', 'pic', 'file']
      end

      # Use callbacks to share common setup or constraints between actions.
      def set_reservation
        @reservation = Reservation.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def reservation_params
        params.require(:reservation).permit(:origin, :arrival, :origin_location, :arrival_location,
                                            :airline_origin, :airline_arrival, :flight_number_origin, :flight_number_arrival,
                                            :flight_origin, :flight_arrival, :quantity_adults, :quantity_kids,
                                            :quantity_kit, :round_trip, :airport_origin, :position, :deleted_at,
                                            travellers_attributes: [:name, :dni])
      end

      def show_history
        get_history(Reservation)
      end

      def get_history(model)
        @activities = PublicActivity::Activity.where(
          trackable_type: model.to_s
        ).order('created_at desc').limit(50)
      end

      # Get submit key to redirect, only [:create, :update]
      def redirect(object, commit)
        if commit.key?('_save')
          redirect_to([:admin, :travel, object], notice: actions_messages(object))
        elsif commit.key?('_add_other')
          redirect_to(
            send("new_admin_travel_#{object.model_name.element}_path"),
            notice: actions_messages(object)
          )
        end
      end
    end
  end
end
