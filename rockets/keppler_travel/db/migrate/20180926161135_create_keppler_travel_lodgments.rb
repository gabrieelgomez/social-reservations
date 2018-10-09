class CreateKepplerTravelLodgments < ActiveRecord::Migration[5.2]
  def change
    create_table :keppler_travel_lodgments do |t|
      t.jsonb      :title
      t.jsonb      :address
      t.string     :email
      t.integer    :phone_one
      t.integer    :phone_two
      t.jsonb      :files
      t.boolean    :status, default: true
      t.string     :type_rooms, array: true
      t.belongs_to :destination
      t.belongs_to :ranking
      t.datetime   :deleted_at
      t.integer    :position
      t.timestamps
    end
    add_index :keppler_travel_lodgments, :deleted_at
  end
end
