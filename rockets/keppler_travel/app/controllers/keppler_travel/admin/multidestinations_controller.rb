require_dependency "keppler_travel/application_controller"
module KepplerTravel
  module Admin
    # MultidestinationsController
    class MultidestinationsController < ApplicationController
      layout 'keppler_travel/admin/layouts/application'
      before_action :set_multidestination, only: [:show, :edit, :update, :destroy, :rooms_tables]
      before_action :show_history, only: [:index]
      before_action :set_attachments
      before_action :authorization
      include KepplerTravel::Concerns::Commons
      include KepplerTravel::Concerns::History
      include KepplerTravel::Concerns::DestroyMultiple


      # GET /multidestinations
      def index
        @q = Multidestination.ransack(params[:q])
        multidestinations = @q.result(distinct: true)
        @objects = multidestinations.page(@current_page).order(position: :asc)
        @total = multidestinations.size
        @multidestinations = @objects.all
        if !@objects.first_page? && @objects.size.zero?
          redirect_to multidestinations_path(page: @current_page.to_i.pred, search: @query)
        end
        respond_to do |format|
          format.html
          format.xls { send_data(@multidestinations.to_xls) }
          format.json { render :json => @objects }
        end
      end

      # GET /multidestinations/1
      def show
      end

      # GET /multidestinations/new
      def new
        @multidestination = Multidestination.new
      end

      # GET /multidestinations/1/edit
      def edit
      end

      # POST /multidestinations
      def create
        @multidestination = Multidestination.new(multidestination_params)
        @multidestination.destination_ids = params[:multidestination][:destination_ids].split(',').map(&:to_i)
        if @multidestination.save!
          @multidestinationable = MultidestinationableService.create(@multidestination, params)
          redirect_to admin_travel_multidestination_rooms_tables_path(@multidestination)
          # redirect(@multidestination, params)
        else
          render :new
        end
      end

      # PATCH/PUT /multidestinations/1
      def update
        ids = params[:multidestination][:destination_ids].try(:split, ',').try(:map, &:to_i)
        if @multidestination.update(multidestination_params)
          @multidestination.update_images(params[:multidestination])
          @multidestination.update(destination_ids: ids) if ids
          redirect(@multidestination, params)
        else
          render :edit
        end
      end

      def rooms_tables
        MultidestinationableService.update_multidestinationable(@multidestination)
      end

      def clone
        @multidestination = Multidestination.clone_record params[:multidestination_id]

        if @multidestination.save
          redirect_to admin_travel_multidestinations_path
        else
          render :new
        end
      end

      # DELETE /multidestinations/1
      def destroy
        @multidestination.destroy
        redirect_to admin_travel_multidestinations_path, notice: actions_messages(@multidestination)
      end

      def destroy_multiple
        Multidestination.destroy redefine_ids(params[:multiple_ids])
        redirect_to(
          admin_travel_multidestinations_path(page: @current_page, search: @query),
          notice: actions_messages(Multidestination.new)
        )
      end

      def upload
        Multidestination.upload(params[:file])
        redirect_to(
          admin_multidestinations_path(page: @current_page, search: @query),
          notice: actions_messages(Multidestination.new)
        )
      end

      def download
        @multidestinations = Multidestination.all
        respond_to do |format|
          format.html
          format.xls { send_data(@multidestinations.to_xls) }
          format.json { render json: @multidestinations }
        end
      end

      def reload
        @q = Multidestination.ransack(params[:q])
        multidestinations = @q.result(distinct: true)
        @objects = multidestinations.page(@current_page).order(position: :desc)
      end

      def sort
        Multidestination.sorter(params[:row])
        @q = Multidestination.ransack(params[:q])
        multidestinations = @q.result(distinct: true)
        @objects = multidestinations.page(@current_page)
        render :index
      end

      private

      def authorization
        authorize Multidestination
      end

      def set_attachments
        @attachments = ['logo', 'brand', 'photo', 'avatar', 'cover', 'image',
                        'picture', 'banner', 'attachment', 'pic', 'file']
        @language = [:en, :es, :pt]
      end

      # Use callbacks to share common setup or constraints between actions.
      def set_multidestination
        @multidestination = Multidestination.find(params[:id]) rescue Multidestination.find(params[:multidestination_id])
      end

      # Only allow a trusted parameter "white list" through.
      def multidestination_params
        params.require(:multidestination).permit(:quantity_days, :price, :banner, :featured, :position, :deleted_at, :status, multidestinationables_attributes: [:id, :status], multidestinationable_rooms_attributes: [:id, :price_cop, :price_usd],
        title: @language, description: @language, include: @language, exclude: @language, itinerary: @language)
      end

      def show_history
        get_history(Multidestination)
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
