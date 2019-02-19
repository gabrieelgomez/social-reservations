module App
  module Dashboard
    module Agencies

      class AgenciesController < DashboardController
        before_action :set_agent, only: [:show, :edit, :destroy, :update_agent]

        def agencies
          @agency = current_user.agency
          @agents = @agency.agents
        end

        # GET /agents/new
        def new_agent
          @agency = current_user.agency
          @user   = User.new
          @agent  = KepplerTravel::Agent.new
        end

        # POST /agents
        def create_agent
          @user = User.new(user_params)
          password = Devise.friendly_token.first(8)
          @user.password = password
          @user.password_confirmation = password
          @user.format_accessable_passwd(password)
          @agent  = @user.build_agent(agency_id: params[:agency_id])
          @agency = Agency.find(params[:agency_id])
          if @user.save
            @user.add_role :agent
            ReservationMailer.send_password(@user).deliver_now
            redirect_to agents_listing_path(@lang, @currency)
          else
            render :new_agent
          end
        end

        def edit_agent
          @agency = current_user.agency
          @agent  = KepplerTravel::Agent.find(params[:agent_id])
          @user   = @agent.user
        end

        def update_password
          return if user_params[:password].blank?
          @user.format_accessable_passwd(user_params[:password])
        end

        # PATCH/PUT /agents/1
        def update_agent
          update_attributes = user_params.delete_if do |_, value|
            value.blank?
          end
          if @user.update_attributes(update_attributes)
            redirect_to agents_listing_path(@lang, @currency)
          else
            render :edit_agent
          end
        end

        # DELETE /agents/1
        def destroy
          @agent.user.destroy
          redirect_to admin_travel_agency_agents_path, notice: actions_messages(@agent)
        end

        private

        def set_agent
          @agency = current_user.agency
          @agent  = @agency.agents.find(params[:agent_id])
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

      end

    end
  end
end
