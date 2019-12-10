class CreateWarpCountObservations < ActiveRecord::Migration[5.2]
  def change
    create_table :warp_count_observations do |t|
      t.integer :count, null: false
      t.text :notes
      t.boolean :is_valid, null: false, default: true
      t.references :work_space_polling_station, null: false
      t.references :user, null: false

      t.timestamps null: false
    end
  end
end
