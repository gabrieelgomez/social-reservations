class CreateKepplerTravelAgencies < ActiveRecord::Migration[5.2]
  def change
    create_table :keppler_travel_agencies do |t|
      t.string :unique_code, default: SecureRandom.hex(3).upcase
      t.float :comission_percentage, default: 0
      t.float :lending_percentage, default: 0
      t.belongs_to :user, index: true
      t.integer :position
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :keppler_travel_agencies, :deleted_at
  end
end
