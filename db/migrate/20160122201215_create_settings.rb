class CreateSettings < ActiveRecord::Migration[5.1]
  def change
    create_table :settings do |t|
      t.string :name
      t.string :description
      t.string :phone
      t.string :mobile
      t.string :email
      t.string :logo
      t.string :favicon
      t.text   :terms_conditions
      t.text   :privacy_policies
      t.text   :cancellations

      t.timestamps null: false
    end
  end
end
