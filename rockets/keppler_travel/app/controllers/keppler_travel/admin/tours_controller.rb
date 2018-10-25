require_dependency "keppler_travel/application_controller"
module KepplerTravel
  module Admin
    # ToursController
    class ToursController < ApplicationController
      layout 'keppler_travel/admin/layouts/application'
      before_action :set_tour, only: [:show, :edit, :update, :destroy]
      before_action :show_history, only: [:index]
      before_action :set_attachments
      before_action :authorization
      include KepplerTravel::Concerns::Commons
      include KepplerTravel::Concerns::History
      include KepplerTravel::Concerns::DestroyMultiple


      # GET /tours
      def index
        @q = Tour.ransack(params[:q])
        tours = @q.result(distinct: true)
        @objects = tours.page(@current_page).order(position: :asc)
        @total = tours.size
        @tours = @objects.all
        if !@objects.first_page? && @objects.size.zero?
          redirect_to tours_path(page: @current_page.to_i.pred, search: @query)
        end
        respond_to do |format|
          format.html
          format.xls { send_data(@tours.to_xls) }
          format.json { render :json => @objects }
        end
      end

      # GET /tours/1
      def show
      end

      # GET /tours/new
      def new
        @tour = Tour.new
      end

      # GET /tours/1/edit
      def edit
      end

      # POST /tours
      def create
        @tour = Tour.new(tour_params)
        @tour.destination_ids = params[:tour][:destination_ids].split(',').map(&:to_i)
        if @tour.save
          redirect(@tour, params)
        else
          render :new
        end
      end

      # PATCH/PUT /tours/1
      def update
        ids = params[:tour][:destination_ids].split(',').map(&:to_i)
        @tour.update_images(params[:tour])
        if @tour.update(tour_params)
          @tour.update(destination_ids: ids)
          redirect(@tour, params)
        else
          render :edit
        end
      end

      def clone
        @tour = Tour.clone_record params[:tour_id]

        if @tour.save
          redirect_to admin_travel_tours_path
        else
          render :new
        end
      end

      # DELETE /tours/1
      def destroy
        @tour.destroy
        redirect_to admin_travel_tours_path, notice: actions_messages(@tour)
      end

      def destroy_multiple
        Tour.destroy redefine_ids(params[:multiple_ids])
        redirect_to(
          admin_travel_tours_path(page: @current_page, search: @query),
          notice: actions_messages(Tour.new)
        )
      end

      def upload
        Tour.upload(params[:file])
        redirect_to(
          admin_tours_path(page: @current_page, search: @query),
          notice: actions_messages(Tour.new)
        )
      end

      def download
        @tours = Tour.all
        respond_to do |format|
          format.html
          format.xls { send_data(@tours.to_xls) }
          format.json { render json: @tours }
        end
      end

      def reload
        @q = Tour.ransack(params[:q])
        tours = @q.result(distinct: true)
        @objects = tours.page(@current_page).order(position: :desc)
      end

      def sort
        Tour.sorter(params[:row])
        @q = Tour.ransack(params[:q])
        tours = @q.result(distinct: true)
        @objects = tours.page(@current_page)
        render :index
      end

      private

      def authorization
        authorize Tour
      end

      def set_attachments
        @attachments = ['logo', 'brand', 'photo', 'avatar', 'cover', 'image',
                        'picture', 'banner', 'attachment', 'pic', 'file']
        @language = [:en, :es, :pt]
        @currency = [:cop, :usd]
      end

      # Use callbacks to share common setup or constraints between actions.
      def set_tour
        @tour = Tour.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def tour_params
        params.require(:tour).permit(:position, :deleted_at, :featured, :banner, :status, files:[], title: @language, subtitle: @language, description: @language, task: @language, price_adults: @currency, price_kids: @currency)
      end

      def show_history
        get_history(Tour)
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
