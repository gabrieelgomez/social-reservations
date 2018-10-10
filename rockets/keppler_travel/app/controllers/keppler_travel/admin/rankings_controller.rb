require_dependency "keppler_travel/application_controller"
module KepplerTravel
  module Admin
    # RankingsController
    class RankingsController < ApplicationController
      layout 'keppler_travel/admin/layouts/application'
      before_action :set_ranking, only: [:show, :edit, :update, :destroy]
      before_action :show_history, only: [:index]
      before_action :set_attachments
      before_action :authorization
      include KepplerTravel::Concerns::Commons
      include KepplerTravel::Concerns::History
      include KepplerTravel::Concerns::DestroyMultiple


      # GET /rankings
      def index
        @q = Ranking.ransack(params[:q])
        rankings = @q.result(distinct: true)
        @objects = rankings.page(@current_page).order(position: :asc)
        @total = rankings.size
        @rankings = @objects.all
        if !@objects.first_page? && @objects.size.zero?
          redirect_to rankings_path(page: @current_page.to_i.pred, search: @query)
        end
        respond_to do |format|
          format.html
          format.xls { send_data(@rankings.to_xls) }
          format.json { render :json => @objects }
        end
      end

      # GET /rankings/1
      def show
      end

      # GET /rankings/new
      def new
        @ranking = Ranking.new
      end

      # GET /rankings/1/edit
      def edit
      end

      # POST /rankings
      def create
        @ranking = Ranking.new(ranking_params)

        if @ranking.save
          redirect(@ranking, params)
        else
          render :new
        end
      end

      # PATCH/PUT /rankings/1
      def update
        if @ranking.update(ranking_params)
          redirect(@ranking, params)
        else
          render :edit
        end
      end

      def clone
        @ranking = Ranking.clone_record params[:ranking_id]

        if @ranking.save
          redirect_to admin_travel_rankings_path
        else
          render :new
        end
      end

      # DELETE /rankings/1
      def destroy
        @ranking.destroy
        redirect_to admin_travel_rankings_path, notice: actions_messages(@ranking)
      end

      def destroy_multiple
        Ranking.destroy redefine_ids(params[:multiple_ids])
        redirect_to(
          admin_travel_rankings_path(page: @current_page, search: @query),
          notice: actions_messages(Ranking.new)
        )
      end

      def upload
        Ranking.upload(params[:file])
        redirect_to(
          admin_rankings_path(page: @current_page, search: @query),
          notice: actions_messages(Ranking.new)
        )
      end

      def download
        @rankings = Ranking.all
        respond_to do |format|
          format.html
          format.xls { send_data(@rankings.to_xls) }
          format.json { render json: @rankings }
        end
      end

      def reload
        @q = Ranking.ransack(params[:q])
        rankings = @q.result(distinct: true)
        @objects = rankings.page(@current_page).order(position: :desc)
      end

      def sort
        Ranking.sorter(params[:row])
        @q = Ranking.ransack(params[:q])
        rankings = @q.result(distinct: true)
        @objects = rankings.page(@current_page)
        render :index
      end

      private

      def authorization
        authorize Ranking
      end

      def set_attachments
        @attachments = ['logo', 'brand', 'photo', 'avatar', 'cover', 'image',
                        'picture', 'banner', 'attachment', 'pic', 'file']
      end

      # Use callbacks to share common setup or constraints between actions.
      def set_ranking
        @ranking = Ranking.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def ranking_params
        params.require(:ranking).permit(:title, :position, :deleted_at)
      end

      def show_history
        get_history(Ranking)
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
