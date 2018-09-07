require_dependency "keppler_travel/application_controller"
module KepplerTravel
  module Admin
    # VehiclesController
    class VehiclesController < ApplicationController
      layout 'keppler_travel/admin/layouts/application'
      before_action :set_vehicle, only: [:show, :edit, :update, :destroy]
      before_action :show_history, only: [:index]
      before_action :set_attachments
      before_action :authorization
      include KepplerTravel::Concerns::Commons
      include KepplerTravel::Concerns::History
      include KepplerTravel::Concerns::DestroyMultiple
      include ObjectQuery

      # GET /vehicles
      def index
        @q = Vehicle.ransack(params[:q])
        vehicles = @q.result(distinct: true)
        @objects = vehicles.page(@current_page).order(position: :asc)
        @total = vehicles.size
        @vehicles = @objects.all
        if !@objects.first_page? && @objects.size.zero?
          redirect_to vehicles_path(page: @current_page.to_i.pred, search: @query)
        end
        respond_to_formats(@vehicles)
      end

      # GET /vehicles/1
      def show
      end

      # GET /vehicles/new
      def new
        @vehicle = Vehicle.new
      end

      # GET /vehicles/1/edit
      def edit
      end

      # POST /vehicles
      def create
        @vehicle = Vehicle.new(vehicle_params)
        # @vehicle.destination_ids = params[:vehicle][:destination_ids].split(',').map(&:to_i)
        if @vehicle.save
          redirect(@vehicle, params)
        else
          render :new
        end
      end

      # PATCH/PUT /vehicles/1
      def update
        # @vehicle.destination_ids = params[:vehicle][:destination_ids].split(',').map(&:to_i)
        @vehicle.update_images(params[:vehicle])
        @vehicle.update(vehicle_params)
        if @vehicle.save
          redirect(@vehicle, params)
        else
          render :edit
        end
      end

      def clone
        @vehicle = Vehicle.clone_record params[:vehicle_id]

        if @vehicle.save
          redirect_to admin_travel_vehicles_path
        else
          render :new
        end
      end

      # DELETE /vehicles/1
      def destroy
        @vehicle.destroy
        redirect_to admin_travel_vehicles_path, notice: actions_messages(@vehicle)
      end

      def destroy_multiple
        Vehicle.destroy redefine_ids(params[:multiple_ids])
        redirect_to(
          admin_travel_vehicles_path(page: @current_page, search: @query),
          notice: actions_messages(Vehicle.new)
        )
      end

      def upload
        Vehicle.upload(params[:file])
        redirect_to(
          admin_vehicles_path(page: @current_page, search: @query),
          notice: actions_messages(Vehicle.new)
        )
      end

      def download
        @vehicles = Vehicle.all
        respond_to do |format|
          format.html
          format.xls { send_data(@vehicles.to_xls) }
          format.json { render json: @vehicles }
        end
      end

      def reload
        @q = Vehicle.ransack(params[:q])
        vehicles = @q.result(distinct: true)
        @objects = vehicles.page(@current_page).order(position: :desc)
      end

      def sort
        Vehicle.sorter(params[:row])
        @q = Vehicle.ransack(params[:q])
        vehicles = @q.result(distinct: true)
        @objects = vehicles.page(@current_page)
        render :index
      end

      private

      def authorization
        authorize Vehicle
      end

      def set_attachments
        @attachments = ['logo', 'brand', 'photo', 'avatar', 'cover', 'image',
                        'picture', 'banner', 'attachment', 'pic', 'file']
        @language = [:en, :es, :pt]
      end

      # Use callbacks to share common setup or constraints between actions.
      def set_vehicle
        @vehicle = Vehicle.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def vehicle_params
        params.require(:vehicle).permit(:cover, :quantity_adults, :quantity_kids, :position, :deleted_at,
          :date, :time, :seat, {files:[]}, price: [:cop, :usd], kit: [:quantity, :weight],
          title: @language, description: @language, includes: @language, conditions: @language)
      end

      def show_history
        get_history(Vehicle)
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
