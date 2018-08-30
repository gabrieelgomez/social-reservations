require_dependency "keppler_travel/application_controller"
module KepplerTravel
  module Admin
    # TransfersController
    class TransfersController < ApplicationController
      layout 'keppler_travel/admin/layouts/application'
      before_action :set_transfer, only: [:show, :edit, :update, :destroy]
      before_action :show_history, only: [:index]
      before_action :set_attachments
      before_action :authorization
      include KepplerTravel::Concerns::Commons
      include KepplerTravel::Concerns::History
      include KepplerTravel::Concerns::DestroyMultiple


      # GET /transfers
      def index
        @q = Transfer.ransack(params[:q])
        transfers = @q.result(distinct: true)
        @objects = transfers.page(@current_page).order(position: :asc)
        @total = transfers.size
        @transfers = @objects.all
        if !@objects.first_page? && @objects.size.zero?
          redirect_to transfers_path(page: @current_page.to_i.pred, search: @query)
        end
        respond_to do |format|
          format.html
          format.xls { send_data(@transfers.to_xls) }
          format.json { render :json => @objects }
        end
      end

      # GET /transfers/1
      def show
      end

      # GET /transfers/new
      def new
        @transfer = Transfer.new
      end

      # GET /transfers/1/edit
      def edit
      end

      # POST /transfers
      def create
        @transfer = Transfer.new(transfer_params)
        # @transfer.destination_ids = params[:transfer][:destination_ids].split(',').map(&:to_i)
        # byebug
        if @transfer.save
          redirect(@transfer, params)
        else
          render :new
        end
      end

      # PATCH/PUT /transfers/1
      def update
        # @transfer.destination_ids = params[:transfer][:destination_ids].split(',').map(&:to_i)
        @transfer.update_images(params[:transfer])
        @transfer.update(transfer_params)
        if @transfer.save
          redirect(@transfer, params)
        else
          render :edit
        end
      end

      def clone
        @transfer = Transfer.clone_record params[:transfer_id]

        if @transfer.save
          redirect_to admin_travel_transfers_path
        else
          render :new
        end
      end

      # DELETE /transfers/1
      def destroy
        @transfer.destroy
        redirect_to admin_travel_transfers_path, notice: actions_messages(@transfer)
      end

      def destroy_multiple
        Transfer.destroy redefine_ids(params[:multiple_ids])
        redirect_to(
          admin_travel_transfers_path(page: @current_page, search: @query),
          notice: actions_messages(Transfer.new)
        )
      end

      def upload
        Transfer.upload(params[:file])
        redirect_to(
          admin_transfers_path(page: @current_page, search: @query),
          notice: actions_messages(Transfer.new)
        )
      end

      def download
        @transfers = Transfer.all
        respond_to do |format|
          format.html
          format.xls { send_data(@transfers.to_xls) }
          format.json { render json: @transfers }
        end
      end

      def reload
        @q = Transfer.ransack(params[:q])
        transfers = @q.result(distinct: true)
        @objects = transfers.page(@current_page).order(position: :desc)
      end

      def sort
        Transfer.sorter(params[:row])
        @q = Transfer.ransack(params[:q])
        transfers = @q.result(distinct: true)
        @objects = transfers.page(@current_page)
        render :index
      end

      private

      def authorization
        authorize Transfer
      end

      def set_attachments
        @attachments = ['logo', 'brand', 'photo', 'avatar', 'cover', 'image',
                        'picture', 'banner', 'attachment', 'pic', 'file']
        @language = [:en, :es, :pt]
      end

      # Use callbacks to share common setup or constraints between actions.
      def set_transfer
        @transfer = Transfer.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def transfer_params
        params.require(:transfer).permit(:cover, :quantity_adults, :quantity_kids, :date, :time, :position, :deleted_at, {files:[]},
          price: [:cop, :usd], title: @language, description: @language)
      end

      def show_history
        get_history(Transfer)
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
