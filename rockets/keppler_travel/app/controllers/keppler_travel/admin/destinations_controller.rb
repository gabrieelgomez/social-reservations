require_dependency "keppler_travel/application_controller"
module KepplerTravel
  module Admin
    # DestinationsController
    class DestinationsController < ApplicationController
      layout 'keppler_travel/admin/layouts/application'
      before_action :set_destination, only: [:show, :edit, :update, :destroy]
      before_action :show_history, only: [:index]
      before_action :set_attachments
      before_action :authorization
      include KepplerTravel::Concerns::Commons
      include KepplerTravel::Concerns::History
      include KepplerTravel::Concerns::DestroyMultiple


      # GET /destinations
      def index
        @q = Destination.ransack(params[:q])
        destinations = @q.result(distinct: true)
        @objects = destinations.page(@current_page).order(position: :asc)
        @total = destinations.size
        @destinations = @objects.all
        if !@objects.first_page? && @objects.size.zero?
          redirect_to destinations_path(page: @current_page.to_i.pred, search: @query)
        end
        respond_to do |format|
          format.html
          format.xls { send_data(@destinations.to_xls) }
          format.json { render :json => @objects }
        end
      end

      # GET /destinations/1
      def show
      end

      # GET /destinations/new
      def new
        @destination = Destination.new
      end

      # GET /destinations/1/edit
      def edit
      end

      # POST /destinations
      def create
        @destination = Destination.new(destination_params)

        if @destination.save
          redirect(@destination, params)
        else
          render :new
        end
      end

      # PATCH/PUT /destinations/1
      def update
        if @destination.update(destination_params)
          redirect(@destination, params)
        else
          render :edit
        end
      end

      def clone
        @destination = Destination.clone_record params[:destination_id]

        if @destination.save
          redirect_to admin_travel_destinations_path
        else
          render :new
        end
      end

      # DELETE /destinations/1
      def destroy
        @destination.destroy
        redirect_to admin_travel_destinations_path, notice: actions_messages(@destination)
      end

      def destroy_multiple
        Destination.destroy redefine_ids(params[:multiple_ids])
        redirect_to(
          admin_travel_destinations_path(page: @current_page, search: @query),
          notice: actions_messages(Destination.new)
        )
      end

      def upload
        Destination.upload(params[:file])
        redirect_to(
          admin_destinations_path(page: @current_page, search: @query),
          notice: actions_messages(Destination.new)
        )
      end

      def download
        @destinations = Destination.all
        respond_to do |format|
          format.html
          format.xls { send_data(@destinations.to_xls) }
          format.json { render json: @destinations }
        end
      end

      def reload
        @q = Destination.ransack(params[:q])
        destinations = @q.result(distinct: true)
        @objects = destinations.page(@current_page).order(position: :desc)
      end

      def sort
        Destination.sorter(params[:row])
        @q = Destination.ransack(params[:q])
        destinations = @q.result(distinct: true)
        @objects = destinations.page(@current_page)
        render :index
      end

      private

      def authorization
        authorize Destination
      end

      def set_attachments
        @attachments = ['logo', 'brand', 'photo', 'avatar', 'cover', 'image',
                        'picture', 'banner', 'attachment', 'pic', 'file']
      end

      # Use callbacks to share common setup or constraints between actions.
      def set_destination
        @destination = Destination.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def destination_params
        params.require(:destination).permit(:title, :custom_title, :latitude, :longitude, :position, :deleted_at)
      end

      def show_history
        get_history(Destination)
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
