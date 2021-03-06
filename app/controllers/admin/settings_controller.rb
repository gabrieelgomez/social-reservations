# frozen_string_literal: true

module Admin
  # SettingsController
  class SettingsController < AdminController
    before_action :set_setting, only: %i[edit update appearance_default]
    before_action :authorization, except: %i[reload appearance_default]

    def edit
      @social_medias = social_account_permit_attributes
      @colors = social_account_colors
    end

    def update
      if @setting.update(setting_params)
        appearance_service.get_color(params[:color])
        redirect_to(
          admin_settings_path(@render), notice: actions_messages(@setting)
        )
      else
        render :edit
      end
    end

    def appearance_default
      appearance_service.set_default
      redirect_to(
        admin_settings_path(@render), notice: actions_messages(@setting)
      )
    end

    private

    def appearance_service
      Admin::AppearanceService.new
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_setting
      @setting = Setting.first
      @render = params[:config]
    end

    def authorization
      authorize Setting
    end

    # Only allow a trusted parameter "white list" through.
    def setting_params
      params.require(:setting).permit(
        :name, :description, :email, :phone, :mobile, :logo,
        :favicon, :logo_cache, :favicon_cache,
        :terms_conditions_es, :terms_conditions_en, :terms_conditions_pt,
        :privacy_policies_es, :privacy_policies_en, :privacy_policies_pt,
        :cancellations_es, :cancellations_en, :cancellations_pt,
        smtp_setting_attributes: smpt_setting_permit_attributes,
        google_analytics_setting_attributes: ga_setting_permit_attributes,
        social_account_attributes: social_account_permit_attributes,
        sheetsu_setting_attributes: sheetsu_setting_permit_attributes,
        appearance_attributes: apparence_permit_attributes
      )
    end

    def smpt_setting_permit_attributes
      %i[id address port domain_name email password]
    end

    def ga_setting_permit_attributes
      %i[ga_account_id ga_tracking_id ga_status]
    end

    def social_account_permit_attributes
      %i[
        facebook twitter instagram google_plus
        tripadvisor pinterest flickr behance
        dribbble tumblr github linkedin
        soundcloud youtube skype vimeo
      ]
    end

    def sheetsu_setting_permit_attributes
      %i[
        id
        sheetsu_url_tours sheetsu_code_tours sheetsu_spreadsheet_tours
        sheetsu_url_circuits sheetsu_code_circuits sheetsu_spreadsheet_circuits
        sheetsu_url_multidestinations sheetsu_code_multidestinations sheetsu_spreadsheet_multidestinations
      ]
    end

    def social_account_colors
      %w[
        #3b5998 #1da1f2 #e1306c #dd4b39
        #00af87 #bd081c #ff0084 #1769ff
        #ff8833 #35465c #333333 #0077b5
        #ff8800 #ff0000 #00aff0 #162221
      ]
    end

    def apparence_permit_attributes
      %i[
        id theme_name image_background
        image_background_cache remove_image_background
      ]
    end
  end
end
