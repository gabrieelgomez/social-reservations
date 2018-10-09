class CreateKepplerTravelSquareCircuits < ActiveRecord::Migration[5.2]
  def change
    create_table :keppler_travel_square_circuits do |t|
      t.integer :single
      t.integer :doubles
      t.integer :triples
      t.integer :quadruples
      t.integer :quintuples
      t.integer :sextuples
      t.integer :children
      t.belongs_to :lodgment
      t.belongs_to :reservation
      t.timestamps
    end
  end
end
