require_dependency "keppler_travel/application_controller"
module KepplerTravel
  module Admin
    # AgentsController
    class AgentsController < ApplicationController
      layout 'keppler_travel/admin/layouts/application'
      before_action :set_agent, only: [:show, :edit, :destroy, :update_user]
      before_action :show_history, only: [:index]
      before_action :set_attachments
      before_action :authorization
      include KepplerTravel::Concerns::Commons
      include KepplerTravel::Concerns::History
      include KepplerTravel::Concerns::DestroyMultiple


      # GET /agents
      def index
        @agency = Agency.find(params[:agency_id])
        @q = Agent.ransack(params[:q])
        agents = @q.result(distinct: true).where(agency_id: @agency)
        @objects = agents.page(@current_page).order(position: :asc)
        @total = agents.size
        @agents = @objects.all
        if !@objects.first_page? && @objects.size.zero?
          redirect_to agents_path(page: @current_page.to_i.pred, search: @query)
        end
        respond_to do |format|
          format.html
          format.xls { send_data(@agents.to_xls) }
          format.json { render :json => @objects }
        end
      end

      # GET /agents/1
      def show
      end

      # GET /agents/new
      def new
        @user   = User.new
        @agent  = Agent.new
        @agency = Agency.find(params[:agency_id])
      end

      # GET /agents/1/edit
      def edit
      end

      # POST /agents
      def create
        @user = User.new(user_params)
        password = Devise.friendly_token.first(8)
        @user.password = password
        @user.password_confirmation = password
        @user.format_accessable_passwd(password)
        @agent  = @user.build_agent(agency_id: params[:agency_id])
        @agency = Agency.find(params[:agency_id])
        @agent.unique_code = @agency.unique_code
        if @user.save
          @user.add_role :agent
          ReservationMailer.send_password(@user).deliver_now
          redirect(@user.agent, params)
        else
          render :new
        end
      end

      def update_password
        return if user_params[:password].blank?
        @user.format_accessable_passwd(user_params[:password])
      end

      # PATCH/PUT /agents/1
      def update_user
        update_attributes = user_params.delete_if do |_, value|
          value.blank?
        end
        if @user.update_attributes(update_attributes)
          redirect(@user.agent, params)
        else
          render :edit
        end
      end

      def clone
        @agent = Agent.clone_record params[:agent_id]

        if @agent.save
          redirect_to admin_travel_agency_agents_path
        else
          render :new
        end
      end

      # DELETE /agents/1
      def destroy
        @agent.user.destroy
        redirect_to admin_travel_agency_agents_path, notice: actions_messages(@agent)
      end

      def destroy_multiple
        Agent.destroy redefine_ids(params[:multiple_ids])
        redirect_to(
          admin_travel_agency_agents_path(page: @current_page, search: @query),
          notice: actions_messages(Agent.new)
        )
      end

      def upload
        Agent.upload(params[:file])
        redirect_to(
          admin_agents_path(page: @current_page, search: @query),
          notice: actions_messages(Agent.new)
        )
      end

      def download
        @agents = Agent.all
        respond_to do |format|
          format.html
          format.xls { send_data(@agents.to_xls) }
          format.json { render json: @agents }
        end
      end

      def reload
        @q = Agent.ransack(params[:q])
        agents = @q.result(distinct: true)
        @objects = agents.page(@current_page).order(position: :desc)
      end

      def sort
        Agent.sorter(params[:row])
        @q = Agent.ransack(params[:q])
        agents = @q.result(distinct: true)
        @objects = agents.page(@current_page)
        render :index
      end

      private

      def authorization
        authorize Agent
      end

      def set_attachments
        @attachments = ['logo', 'brand', 'photo', 'avatar', 'cover', 'image',
                        'picture', 'banner', 'attachment', 'pic', 'file']
      end

      # Use callbacks to share common setup or constraints between actions.
      def set_agent
        @agent  = Agent.where(id: (params[:id] || params[:agent_id])).first
        @agency = Agency.find(params[:agency_id])
        @user   = @agent.user
      end

      # Only allow a trusted parameter "white list" through.
      def agent_params
        params.require(:agent).permit(:unique_code, :comission_percentage, :lending_percentage, :user_id, :agency_id, :position, :deleted_at)
      end

      def user_params
        params.require(:user).permit(
          :name, :email, :phone, :dni, :password, :password_confirmation,
          :role_ids, :encrypted_password, :avatar,
          agent_attributes: [:id, :unique_code, :comission_percentage, :lending_percentage, :position, :deleted_at]
        )
      end

      def show_history
        get_history(Agent)
      end

      def get_history(model)
        @activities = PublicActivity::Activity.where(
          trackable_type: model.to_s
        ).order('created_at desc').limit(50)
      end

      # Get submit key to redirect, only [:create, :update]
      def redirect(object, commit)
        if commit.key?('_save')
          redirect_to([:admin, :travel, Agency.find(commit[:agency_id]), object], notice: actions_messages(object))
        elsif commit.key?('_add_other')
          redirect_to(
            send("new_admin_travel_agency_#{object.model_name.element}_path"),
            notice: actions_messages(object)
          )
        end
      end
    end
  end
end
