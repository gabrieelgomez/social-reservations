class CreateKepplerContactusMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :keppler_contactus_messages do |t|
      t.string :name
      t.string :email
      t.string :subject
      t.text :content
      t.boolean :read
      t.integer :position
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :keppler_contactus_messages, :deleted_at
  end
end
