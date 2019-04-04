class CreateKepplerTravelDocuments < ActiveRecord::Migration[5.2]
  def change
    create_table :keppler_travel_documents do |t|
      t.string :file

      t.timestamps
    end
  end
end
