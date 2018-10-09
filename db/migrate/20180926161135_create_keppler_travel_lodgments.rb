class CreateKepplerTravelLodgments < ActiveRecord::Migration[5.2]
  def change
    create_table :keppler_travel_lodgments do |t|
      t.jsonb :title
      t.string :type_rooms, array: true
      t.integer :position
      t.boolean :status, default: true
      t.belongs_to :destination
      t.datetime :deleted_at
      t.timestamps
    end
    add_index :keppler_travel_lodgments, :deleted_at
  end
end
