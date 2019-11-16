class CreateVolunteerTrackingModels < ActiveRecord::Migration[5.2]
  def change
    create_table :committee_rooms do |t|
      t.text :address, null: false
      t.text :organiser_name, null: false
      t.references :work_space, foreign_key: true

      t.timestamps null: false
    end

    add_reference :work_space_polling_stations,
      :committee_room,
      foreign_key: true,
      null: true

    create_table :canvassers_observations do |t|
      t.integer :count, null: false
      t.references :committee_room, null: false
      t.references :user, null: false

      t.timestamps null: false
    end

    create_table :cars_observations do |t|
      t.integer :count, null: false
      t.references :committee_room, null: false
      t.references :user, null: false

      t.timestamps null: false
    end
  end
end
