class CreateKepplerContactusRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :keppler_contactus_requests do |t|
      t.string :name
      t.string :company
      t.string :dni
      t.string :country
      t.string :phone
      t.string :email
      t.text :body
      t.string :options
      t.integer :position
      t.datetime :deleted_at
      t.timestamps
    end
  end
end
