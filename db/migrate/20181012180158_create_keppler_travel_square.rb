class CreateKepplerTravelSquare < ActiveRecord::Migration[5.2]
  def change
    create_table :keppler_travel_squares do |t|
      t.integer :single, default: 0
      t.integer :doubles, default: 0
      t.integer :triples, default: 0
      t.integer :quadruples, default: 0
      t.integer :quintuples, default: 0
      t.integer :sextuples, default: 0
      t.integer :children, default: 0
      t.integer :optional, default: 0
      t.belongs_to :lodgment, index: true
      t.belongs_to :ranking, index: true
      t.belongs_to :reservation, index: true
      t.integer    :squareable_id#, index: {name: 'squareable_id'}
      t.string     :squareable_type#, index: {name: 'squareable_type'}
      t.datetime   :deleted_at
      t.timestamps
    end
  end
end
