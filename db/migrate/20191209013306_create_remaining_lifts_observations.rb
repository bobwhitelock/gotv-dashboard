class CreateRemainingLiftsObservations < ActiveRecord::Migration[5.2]
  def change
    create_table :remaining_lifts_observations do |t|
      t.integer :count, null: false
      t.references :work_space_polling_station, null: false,
        # Because default index name is too long.
        index: { name: 'index_rlo_on_work_space_polling_station_id' }
      t.references :user, null: false

      t.timestamps null: false
    end
  end
end
