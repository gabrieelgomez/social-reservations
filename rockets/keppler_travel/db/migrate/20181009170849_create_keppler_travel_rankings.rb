class CreateKepplerTravelRankings < ActiveRecord::Migration[5.2]
  def change
    create_table :keppler_travel_rankings do |t|
      t.jsonb :title
      t.integer :position
      t.datetime :deleted_at
      t.timestamps
    end
    add_index :keppler_travel_rankings, :deleted_at
  end
end
