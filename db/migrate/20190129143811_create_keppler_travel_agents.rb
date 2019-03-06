class CreateKepplerTravelAgents < ActiveRecord::Migration[5.2]
  def change
    create_table :keppler_travel_agents do |t|
      t.string :unique_code, default: SecureRandom.hex(3).upcase
      t.float :comission_percentage, default: 0
      t.float :lending_percentage, default: 0
      t.belongs_to :user, index: true
      t.belongs_to :agency, index: true
      t.integer :position
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :keppler_travel_agents, :deleted_at
  end
end
