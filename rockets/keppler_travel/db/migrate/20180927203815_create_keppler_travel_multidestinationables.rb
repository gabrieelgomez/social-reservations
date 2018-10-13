class CreateKepplerTravelMultidestinationables < ActiveRecord::Migration[5.2]
  def change
    create_table :keppler_travel_multidestinationables do |t|
      t.belongs_to :destination, index: true
      t.belongs_to :lodgment, index: true
      # t.belongs_to :multidestination, index: true
      t.belongs_to :multidestination, index: {name: 'multidestinationable_multidestination_id'}
      t.boolean :status
      t.datetime :deleted_at
    end
  end
end
