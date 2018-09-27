require_dependency "keppler_travel/application_controller"
module KepplerTravel
  module Admin
    # LodgmentsController
    class LodgmentsController < ApplicationController
      layout 'keppler_travel/admin/layouts/application'
      before_action :set_lodgment, only: [:show, :edit, :update, :destroy]
      before_action :show_history, only: [:index]
      before_action :set_attachments
      before_action :authorization
      include KepplerTravel::Concerns::Commons
      include KepplerTravel::Concerns::History
      include KepplerTravel::Concerns::DestroyMultiple


      # GET /lodgments
      def index
        @q = Lodgment.ransack(params[:q])
        lodgments = @q.result(distinct: true)
        @objects = lodgments.page(@current_page).order(position: :asc)
        @total = lodgments.size
        @lodgments = @objects.all
        if !@objects.first_page? && @objects.size.zero?
          redirect_to lodgments_path(page: @current_page.to_i.pred, search: @query)
        end
        respond_to do |format|
          format.html
          format.xls { send_data(@lodgments.to_xls) }
          format.json { render :json => @objects }
        end
      end

      # GET /lodgments/1
      def show
      end

      # GET /lodgments/new
      def new
        @lodgment = Lodgment.new
      end

      # GET /lodgments/1/edit
      def edit
      end

      # POST /lodgments
      def create
        @lodgment = Lodgment.new(lodgment_params)
        @lodgment.type_rooms = params[:lodgment][:type_rooms].split(',').map(&:to_i)
        if @lodgment.save
          redirect(@lodgment, params)
        else
          render :new
        end
      end

      # PATCH/PUT /lodgments/1
      def update
        ids = params[:lodgment][:type_rooms].split(',').map(&:to_i)
        if @lodgment.update(lodgment_params)
          @lodgment.update(type_rooms: ids)
          redirect(@lodgment, params)
        else
          render :edit
        end
      end

      def clone
        @lodgment = Lodgment.clone_record params[:lodgment_id]

        if @lodgment.save
          redirect_to admin_travel_lodgments_path
        else
          render :new
        end
      end

      # DELETE /lodgments/1
      def destroy
        @lodgment.destroy
        redirect_to admin_travel_lodgments_path, notice: actions_messages(@lodgment)
      end

      def destroy_multiple
        Lodgment.destroy redefine_ids(params[:multiple_ids])
        redirect_to(
          admin_travel_lodgments_path(page: @current_page, search: @query),
          notice: actions_messages(Lodgment.new)
        )
      end

      def upload
        Lodgment.upload(params[:file])
        redirect_to(
          admin_lodgments_path(page: @current_page, search: @query),
          notice: actions_messages(Lodgment.new)
        )
      end

      def download
        @lodgments = Lodgment.all
        respond_to do |format|
          format.html
          format.xls { send_data(@lodgments.to_xls) }
          format.json { render json: @lodgments }
        end
      end

      def reload
        @q = Lodgment.ransack(params[:q])
        lodgments = @q.result(distinct: true)
        @objects = lodgments.page(@current_page).order(position: :desc)
      end

      def sort
        Lodgment.sorter(params[:row])
        @q = Lodgment.ransack(params[:q])
        lodgments = @q.result(distinct: true)
        @objects = lodgments.page(@current_page)
        render :index
      end

      private

      def authorization
        authorize Lodgment
      end

      def set_attachments
        @attachments = ['logo', 'brand', 'photo', 'avatar', 'cover', 'image',
                        'picture', 'banner', 'attachment', 'pic', 'file']
        @language = [:en, :es, :pt]
      end

      # Use callbacks to share common setup or constraints between actions.
      def set_lodgment
        @lodgment = Lodgment.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def lodgment_params
        params.require(:lodgment).permit(:position, :deleted_at, :destination_id, :type_rooms, title: @language)
      end

      def show_history
        get_history(Lodgment)
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
