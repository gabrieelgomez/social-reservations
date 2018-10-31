require_dependency "keppler_contactus/application_controller"
module KepplerContactus
  module Admin
    # RequestsController
    class RequestsController < ApplicationController
      layout 'keppler_contactus/admin/layouts/application', except: [:new]
      # load_and_authorize_resource except: [:create]
      before_action :authenticate_user!, except: [:create]
      before_action :set_request, only: [:show, :edit, :update, :destroy]
      before_action :show_history, only: [:index]
      before_action :set_attachments
      before_action :authorization
      include KepplerContactus::Concerns::Commons
      include KepplerContactus::Concerns::History
      include KepplerContactus::Concerns::DestroyMultiple
      include ObjectQuery

      # GET /requests
      def index
        @q = Request.ransack(params[:q])
        requests = @q.result(distinct: true)
        @objects = requests.page(@current_page).order(position: :desc)
        @total = requests.size
        @requests = @objects.all
        if !@objects.first_page? && @objects.size.zero?
          redirect_to requests_path(page: @current_page.to_i.pred, search: @query)
        end
        respond_to_formats(@requests)
      end

      # GET /requests/1
      def show
      end

      # GET /requests/new
      def new
        @request = Request.new
      end

      # GET /requests/1/edit
      def edit
      end

      # POST /requests
      def create
        @request = Request.new(request_params)
        if verify_recaptcha(model: @request) && @request.save
          # ContactMailer.admin_contact(@request).deliver_now
          # ContactMailer.client_contact(@request).deliver_now
          redirect_to main_app.pqrs_path('usd'), notice: 'saved'
        else
          redirect_to main_app.pqrs_path('usd'), notice: 'not_saved'
        end
      end

      # PATCH/PUT /requests/1
      def update
        if @request.update(request_params)
          redirect(@request, params)
        else
          render :edit
        end
      end

      def clone
        @request = Request.clone_record params[:request_id]

        if @request.save
          redirect_to admin_contactus_requests_path
        else
          render :new
        end
      end

      # DELETE /requests/1
      def destroy
        @request.destroy
        redirect_to admin_contactus_requests_path, notice: actions_messages(@request)
      end

      def destroy_multiple
        Request.destroy redefine_ids(params[:multiple_ids])
        redirect_to(
          admin_contactus_requests_path(page: @current_page, search: @query),
          notice: actions_messages(Request.new)
        )
      end

      def upload
        Request.upload(params[:file])
        redirect_to(
          admin_contactus_requests_path(page: @current_page, search: @query),
          notice: actions_messages(Request.new)
        )
      end

      def download
        @requests = Request.all
        respond_to do |format|
          format.html
          format.xls { send_data(@requests.to_xls) }
          format.json { render json: @requests }
        end
      end

      def reload
        @q = Request.ransack(params[:q])
        requests = @q.result(distinct: true)
        @objects = requests.page(@current_page).order(position: :desc)
      end

      def sort
        Request.sorter(params[:row])
        @q = Request.ransack(params[:q])
        requests = @q.result(distinct: true)
        @objects = requests.page(@current_page)
        render :index
      end

      private

      def authorization
        authorize Request
      end

      def set_attachments
        @attachments = ['logo', 'brand', 'photo', 'avatar', 'cover', 'image',
                        'picture', 'banner', 'attachment', 'pic', 'file']
      end

      # Use callbacks to share common setup or constraints between actions.
      def set_request
        @request = Request.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def request_params
        params.require(:request).permit(:name, :company, :dni, :country, :phone, :email, :body, :options)
      end

      def show_history
        get_history(Request)
      end

      def get_history(model)
        @activities = PublicActivity::Activity.where(
          trackable_type: model.to_s
        ).order('created_at desc').limit(50)
      end

      # Get submit key to redirect, only [:create, :update]
      def redirect(object, commit)
        if commit.key?('_save')
          redirect_to([:admin, :contactus, object], notice: actions_messages(object))
        elsif commit.key?('_add_other')
          redirect_to(
            send("new_admin_contactus_#{underscore(object)}_path"),
            notice: actions_messages(object)
          )
        end
      end
    end
  end
end
