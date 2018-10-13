class CreateKepplerTravelMultidestinationableRoom < ActiveRecord::Migration[5.2]
  def change
    create_table :keppler_travel_multidestinationable_rooms do |t|
      t.float :price_cop
      t.float :price_usd
      t.boolean :status
      t.belongs_to :room, index: true
      # t.belongs_to :multidestinationable, index: true
      t.belongs_to :multidestination, index: {name: 'multidestinationable_room_id'}
      t.datetime :deleted_at
    end
  end
end
