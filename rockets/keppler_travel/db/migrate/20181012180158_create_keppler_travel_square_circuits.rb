class CreateKepplerTravelSquareCircuits < ActiveRecord::Migration[5.2]
  def change
    create_table :keppler_travel_square_circuits do |t|
      t.integer :three_stars
      t.integer :four_stars
      t.integer :five_stars
      t.integer :optional_stars
      t.belongs_to :ranking, index: true
      t.belongs_to :reservation, index: true
      t.datetime :deleted_at
      t.timestamps
    end
  end
end
