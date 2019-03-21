require_dependency "keppler_travel/application_controller"
module KepplerTravel
  module Admin
    # DriversController
    class DriversController < ApplicationController
      layout 'keppler_travel/admin/layouts/application'
      before_action :set_driver, only: [:show, :edit, :update, :destroy, :description_tables, :update_user]
      before_action :show_history, only: [:index]
      before_action :set_attachments
      before_action :authorization
      include KepplerTravel::Concerns::Commons
      include KepplerTravel::Concerns::History
      include KepplerTravel::Concerns::DestroyMultiple
      include ObjectQuery

      # GET /drivers
      def index
        filter_destination
        drivers = @q.result(distinct: true)
        @objects = drivers.page(@current_page).order(position: :asc)
        @total = drivers.size
        @drivers = @objects.all
        if !@objects.first_page? && @objects.size.zero?
          redirect_to drivers_path(page: @current_page.to_i.pred, search: @query)
        end
        respond_to_formats(@drivers)
      end

      def filter_destination
        @destinations = Driver.all.map(&:destination).reject{|dest| dest.nil?}.uniq.sort_by {|dest| dest.custom_title['es']}
        @selected = params[:destination]
        if params[:destination] == 'all'
          @q = Driver.ransack(params[:q])
        else
          @q = Driver.ransack(params[:q]).result.includes(:destination).ransack(destination_title_cont: params[:destination])
        end
      end

      # GET /drivers/1
      def show
      end

      # GET /drivers/new
      def new
        @driver = Driver.new
        @user = User.new
      end

      # GET /drivers/1/edit
      def edit
      end

      # POST /drivers
      def create
        @user = User.new(user_params)
        @user.build_driver(
          timetrack: params[:user][:driver][:timetrack],
          bank: params[:user][:driver][:bank],
          account_type: params[:user][:driver][:account_type],
          account_number: params[:user][:driver][:account_number],
          email_corporative: params[:user][:driver][:email_corporative]
        )
        @driver = @user.driver
        @driver.vehicle_ids = params[:driver][:vehicle_ids].split(',').map(&:to_i)
        @driver.destination_id = params[:driver][:destination_id]

        if @user.save
          @user.add_role :driver
          update_password if params[:user][:driver]
          ReservationMailer.send_password(@user).deliver_now
          @user.driver.vehicles.each do |vehicle|
            KepplerTravel::CarDescription.create(
              license: '',
              color: '',
              driver: @user.driver,
              vehicle: vehicle)
          end
          redirect_to admin_travel_driver_description_tables_path(@user.driver)
        else
          render :new
        end
      end

      # PATCH/PUT /drivers/1
      def update
        if @driver.update(driver_params)
          # redirect(@driver, params)
          redirect_to admin_travel_drivers_path
        else
          render :edit
        end
      end

      def description_tables
        create_car_descriptions if @driver.car_descriptions.empty?
      end

      def create_car_descriptions
        @driver.vehicles.each do |vehicle|
          KepplerTravel::CarDescription.create(
            license: '',
            color: '',
            driver: @driver,
            vehicle: vehicle)
        end
      end

      def update_user
        update_attributes = user_params.delete_if do |_, value|
          value.blank?
        end
        @driver = @user.driver
        # -----
        if @user.update_attributes(update_attributes)
          ids = params[:driver][:vehicle_ids].split(',').map(&:to_i)
          @user.driver.update(vehicle_ids: ids)
          bank           = params[:user][:driver][:bank]
          account_type   = params[:user][:driver][:account_type]
          account_number = params[:user][:driver][:account_number]
          destination    = params[:driver][:destination_id]
          email_corporative    = params[:user][:driver][:email_corporative]
          @user.driver.update(bank: bank) if bank
          @user.driver.update(account_type: account_type) if account_type
          @user.driver.update(account_number: account_number) if account_number
          @user.driver.update(destination_id: destination) if destination
          @user.driver.update(email_corporative: email_corporative) if email_corporative

          update_password
          redirect_to admin_travel_driver_path(@user.driver)
        else
          render :edit
        end
        # -----
      end

      def update_password
        return if user_params[:password].blank?
        @user.format_accessable_passwd(user_params[:password])
      end

      def clone
        @driver = Driver.clone_record params[:driver_id]

        if @driver.save
          redirect_to admin_travel_drivers_path
        else
          render :new
        end
      end

      # DELETE /drivers/1
      def destroy
        @driver.user.destroy
        redirect_to admin_travel_drivers_path, notice: actions_messages(@driver)
      end

      def destroy_multiple
        Driver.destroy redefine_ids(params[:multiple_ids])
        redirect_to(
          admin_travel_drivers_path(page: @current_page, search: @query),
          notice: actions_messages(Driver.new)
        )
      end

      def upload
        Driver.upload(params[:file])
        redirect_to(
          admin_drivers_path(page: @current_page, search: @query),
          notice: actions_messages(Driver.new)
        )
      end

      def download
        @drivers = Driver.all
        respond_to do |format|
          format.html
          format.xls { send_data(@drivers.to_xls) }
          format.json { render json: @drivers }
        end
      end

      def reload
        @q = Driver.ransack(params[:q])
        drivers = @q.result(distinct: true)
        @objects = drivers.page(@current_page).order(position: :desc)
      end

      def sort
        Driver.sorter(params[:row])
        @q = Driver.ransack(params[:q])
        drivers = @q.result(distinct: true)
        @objects = drivers.page(@current_page)
        render :index
      end

      private

      def authorization
        authorize Driver
      end

      def set_attachments
        @attachments = ['logo', 'brand', 'photo', 'avatar', 'cover', 'image',
                        'picture', 'banner', 'attachment', 'pic', 'file']
      end

      # Use callbacks to share common setup or constraints between actions.
      def set_driver
        @driver  = Driver.where(id: (params[:id] || params[:driver_id])).first
        @user = @driver.user
      end

      # Only allow a trusted parameter "white list" through.
      def driver_params
        params.require(:driver).permit(:bank, :account_type, :destination_id, :email_corporative, :account_number, :timetrack, :user_id, :position, :deleted_at, car_descriptions_attributes: [:id, :_destroy, licenses_attributes: [:id, :matricula, :color, :_destroy] ], licenses_attributes: [:id, :matricula, :color, :_destroy])
      end

      def user_params
        params.require(:user).permit(
          :name, :email, :phone, :dni, :password, :password_confirmation,
          :encrypted_password, :avatar,
          driver_attributes: [:id, :timetrack, :bank, :account_type, :account_number, :destination_id, :email_corporative]
        )
      end

      def show_history
        get_history(Driver)
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
