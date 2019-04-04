class CreateKepplerTravelDocuments < ActiveRecord::Migration[5.2]
  def change
    create_table :keppler_travel_documents do |t|
      t.string :file
      t.belongs_to :reservation, index: true
      t.timestamps
    end
  end
end
