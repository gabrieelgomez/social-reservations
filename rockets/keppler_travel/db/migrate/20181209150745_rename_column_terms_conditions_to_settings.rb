class RenameColumnTermsConditionsToSettings < ActiveRecord::Migration[5.2]
  def change
    rename_column :settings, :terms_conditions, :terms_conditions_es
    rename_column :settings, :privacy_policies, :privacy_policies_es
    rename_column :settings, :cancellations, :cancellations_es
  end
end
