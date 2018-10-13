class CreateKepplerTravelSquareMultidestination < ActiveRecord::Migration[5.2]
  def change
    create_table :keppler_travel_square_multidestinations do |t|
      t.integer :single
      t.integer :doubles
      t.integer :triples
      t.integer :quadruples
      t.integer :quintuples
      t.integer :sextuples
      t.integer :children
      t.belongs_to :lodgment, index: true
      t.belongs_to :reservation, index: true
      t.datetime :deleted_at
      t.timestamps
    end
  end
end
