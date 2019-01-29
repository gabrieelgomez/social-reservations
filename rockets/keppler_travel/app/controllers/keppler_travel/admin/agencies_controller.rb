require_dependency "keppler_travel/application_controller"
module KepplerTravel
  module Admin
    # AgenciesController
    class AgenciesController < ApplicationController
      layout 'keppler_travel/admin/layouts/application'
      before_action :set_agency, only: [:show, :edit, :destroy]
      before_action :show_history, only: [:index]
      before_action :set_attachments
      before_action :authorization
      include KepplerTravel::Concerns::Commons
      include KepplerTravel::Concerns::History
      include KepplerTravel::Concerns::DestroyMultiple


      # GET /agencies
      def index
        @q = Agency.ransack(params[:q])
        agencies = @q.result(distinct: true)
        @objects = agencies.page(@current_page).order(position: :asc)
        @total = agencies.size
        @agencies = @objects.all
        if !@objects.first_page? && @objects.size.zero?
          redirect_to agencies_path(page: @current_page.to_i.pred, search: @query)
        end
        respond_to do |format|
          format.html
          format.xls { send_data(@agencies.to_xls) }
          format.json { render :json => @objects }
        end
      end

      # GET /agencies/1
      def show
      end

      # GET /agencies/new
      def new
        @agency = Agency.new
        @user   = User.new
      end

      # GET /agencies/1/edit
      def edit
      end

      # POST /agencies
      def create
        @user = User.new(user_params)
        password = Devise.friendly_token.first(8)
        @user.password = password
        @user.password_confirmation = password
        if @user.save
          @user.add_role :agency
          @user.format_accessable_passwd(password)
          ReservationMailer.send_password(@user).deliver_now
          @user.build_agency(
            comission_percentage: params[:user][:agency][:comission_percentage],
            lending_percentage: params[:user][:agency][:lending_percentage]
          )
          @user.save
          redirect(@user.agency, params)
        else
          render :new
        end
      end

      def update_password
        return if user_params[:password].blank?
        @user.format_accessable_passwd(user_params[:password])
      end

      # PATCH/PUT /agencies/1
      def update_user
        update_attributes = user_params.delete_if do |_, value|
          value.blank?
        end
        @user = User.find_by(email: params[:user][:email])
        if @user.update_attributes(update_attributes)
          cp = params[:user][:agency][:comission_percentage]
          lp = params[:user][:agency][:lending_percentage]
          @user.agency.update(comission_percentage: cp) if cp
          @user.agency.update(lending_percentage: lp) if lp
          redirect(@user.agency, params)
        else
          render :edit
        end
      end

      def clone
        @agency = Agency.clone_record params[:agency_id]

        if @agency.save
          redirect_to admin_travel_agencies_path
        else
          render :new
        end
      end

      # DELETE /agencies/1
      def destroy
        @agency.destroy
        redirect_to admin_travel_agencies_path, notice: actions_messages(@agency)
      end

      def destroy_multiple
        Agency.destroy redefine_ids(params[:multiple_ids])
        redirect_to(
          admin_travel_agencies_path(page: @current_page, search: @query),
          notice: actions_messages(Agency.new)
        )
      end

      def upload
        Agency.upload(params[:file])
        redirect_to(
          admin_agencies_path(page: @current_page, search: @query),
          notice: actions_messages(Agency.new)
        )
      end

      def download
        @agencies = Agency.all
        respond_to do |format|
          format.html
          format.xls { send_data(@agencies.to_xls) }
          format.json { render json: @agencies }
        end
      end

      def reload
        @q = Agency.ransack(params[:q])
        agencies = @q.result(distinct: true)
        @objects = agencies.page(@current_page).order(position: :desc)
      end

      def sort
        Agency.sorter(params[:row])
        @q = Agency.ransack(params[:q])
        agencies = @q.result(distinct: true)
        @objects = agencies.page(@current_page)
        render :index
      end

      private

      def authorization
        authorize Agency
      end

      def set_attachments
        @attachments = ['logo', 'brand', 'photo', 'avatar', 'cover', 'image',
                        'picture', 'banner', 'attachment', 'pic', 'file']
      end

      # Use callbacks to share common setup or constraints between actions.
      def set_agency
        @agency = Agency.find(params[:id])
        @user = @agency.user
      end

      # Only allow a trusted parameter "white list" through.
      def agency_params
        params.require(:agency).permit(:unique_code, :comission_percentage,
          :lending_percentage, :user_id, :position, :deleted_at)
      end

      def user_params
        params.require(:user).permit(
          :name, :email, :phone, :dni, :password, :password_confirmation,
          :role_ids, :encrypted_password, :avatar,
          agency_attributes: [:id, :unique_code, :comission_percentage, :lending_percentage, :position, :deleted_at]
        )
      end

      def show_history
        get_history(Agency)
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
