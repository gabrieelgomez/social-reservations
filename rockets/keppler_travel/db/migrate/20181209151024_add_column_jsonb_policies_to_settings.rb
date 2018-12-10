class AddColumnJsonbPoliciesToSettings < ActiveRecord::Migration[5.2]
  def change
    add_column :settings, :terms_conditions_en, :text
    add_column :settings, :terms_conditions_pt, :text

    add_column :settings, :privacy_policies_en, :text
    add_column :settings, :privacy_policies_pt, :text

    add_column :settings, :cancellations_en, :text
    add_column :settings, :cancellations_pt, :text
  end
end
