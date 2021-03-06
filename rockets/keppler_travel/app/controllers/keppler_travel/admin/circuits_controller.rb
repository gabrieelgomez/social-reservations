require_dependency "keppler_travel/application_controller"
module KepplerTravel
  module Admin
    # CircuitsController
    class CircuitsController < ApplicationController
      layout 'keppler_travel/admin/layouts/application'
      before_action :set_circuit, only: [:show, :edit, :update, :destroy, :rooms_tables]
      before_action :show_history, only: [:index]
      before_action :set_bulk_upload, only: %i[bulk_upload bulk_upload_save]
      before_action :set_attachments
      before_action :authorization
      include KepplerTravel::Concerns::Commons
      include KepplerTravel::Concerns::History
      include KepplerTravel::Concerns::DestroyMultiple
      include ObjectQuery

      # GET /circuits
      def index
        @q = Circuit.ransack(params[:q])
        circuits = @q.result(distinct: true)
        @objects = circuits.page(@current_page).order(position: :asc)
        @total = circuits.size
        @circuits = @objects.all
        if !@objects.first_page? && @objects.size.zero?
          redirect_to circuits_path(page: @current_page.to_i.pred, search: @query)
        end
        respond_to_formats(@circuits)
      end

      def bulk_upload; end

      def bulk_upload_save
        @objects.each do |circuit|
          if circuit.valid?
            if circuit.save
               CircuitableService.create(circuit, nil)
            end
          end
        end

        redirect_to admin_travel_circuits_path
      end

      # GET /circuits/1
      def show
      end

      # GET /circuits/new
      def new
        @circuit = Circuit.new
      end

      # GET /circuits/1/edit
      def edit
      end

      # POST /circuits
      def create
        @circuit = Circuit.new(circuit_params)
        # @circuit.destination_ids = params[:circuit][:destination_ids].split(',').map(&:to_i)
        if @circuit.save
          @circuitable = CircuitableService.create(@circuit, params)
          redirect_to admin_travel_circuit_rooms_tables_path(@circuit)
          # redirect(@circuit, params)
        else
          render :new
        end
      end

      # PATCH/PUT /circuits/1
      def update
        # ids = params[:circuit][:destination_ids].try(:split, ',').try(:map, &:to_i)
        if @circuit.update(circuit_params)
          @circuit.update_images(params[:circuit])
          redirect(@circuit, params)
        else
          render :edit
        end
      end

      def rooms_tables
        # @circuitable = CircuitableService.create(@circuit, params)
      end

      def clone
        @circuit = Circuit.clone_record params[:circuit_id]

        if @circuit.save
          redirect_to admin_travel_circuits_path
        else
          render :new
        end
      end

      # DELETE /circuits/1
      def destroy
        @circuit.destroy
        redirect_to admin_travel_circuits_path, notice: actions_messages(@circuit)
      end

      def destroy_multiple
        Circuit.destroy redefine_ids(params[:multiple_ids])
        redirect_to(
          admin_travel_circuits_path(page: @current_page, search: @query),
          notice: actions_messages(Circuit.new)
        )
      end

      def upload
        Circuit.upload(params[:file])
        redirect_to(
          admin_circuits_path(page: @current_page, search: @query),
          notice: actions_messages(Circuit.new)
        )
      end

      def download
        @circuits = Circuit.all
        respond_to do |format|
          format.html
          format.xls { send_data(@circuits.to_xls) }
          format.json { render json: @circuits }
        end
      end

      def reload
        @q = Circuit.ransack(params[:q])
        circuits = @q.result(distinct: true)
        @objects = circuits.page(@current_page).order(position: :desc)
      end

      def sort
        Circuit.sorter(params[:row])
        @q = Circuit.ransack(params[:q])
        circuits = @q.result(distinct: true)
        @objects = circuits.page(@current_page)
        render :index
      end

      private

      def authorization
        authorize Circuit
      end

      def set_bulk_upload
        @setting_sheetsu = Setting.first.sheetsu_setting
        @objects         = Circuit.bulk_upload(@setting_sheetsu)
        @error_connection = true if @objects.eql?('Sheetsu::NotFoundError')
      rescue SocketError => e
        logger.info e
        @error_connection = true
      end

      def set_attachments
        @attachments = ['logo', 'brand', 'photo', 'avatar', 'cover', 'image',
                        'picture', 'banner', 'attachment', 'pic', 'file']
        @language = [:en, :es, :pt]
      end

      # Use callbacks to share common setup or constraints between actions.
      def set_circuit
        @circuit = Circuit.find(params[:id]) rescue Circuit.find(params[:circuit_id])
      end

      # Only allow a trusted parameter "white list" through.
      def circuit_params
        params.require(:circuit).permit(:quantity_days, :price, :featured, :banner, :position, :deleted_at, :status, circuitables_attributes: [:id, :status], circuitable_rooms_attributes: [:id, :price_cop, :price_usd, :night_price_cop, :night_price_usd],
        title: @language, subtitle: @language, description: @language, include: @language, exclude: @language, itinerary: @language)
      end

      def show_history
        get_history(Circuit)
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
