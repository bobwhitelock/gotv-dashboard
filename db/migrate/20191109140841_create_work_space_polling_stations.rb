class CreateWorkSpacePollingStations < ActiveRecord::Migration[5.2]
  def change
    create_table :work_space_polling_stations do |t|
      t.references :polling_station, null: false
      t.references :work_space, null: false
      t.integer :pre_election_registered_voters, null: false
      t.integer :pre_election_labour_promises, null: false

      t.timestamps null: false
    end

    remove_column :polling_stations,
      :pre_election_registered_voters,
      :integer,
      null: false,
      default: 0
    remove_column :polling_stations,
      :pre_election_labour_promises,
      :integer,
      null: false,
      default: 0

    remove_reference :turnout_observations,
      :polling_station,
      foreign_key: true,
      null: false,
      default: 0
    remove_reference :turnout_observations,
      :work_space,
      foreign_key: true,
      null: false,
      default: 0
    add_reference :turnout_observations,
      :work_space_polling_station,
      foreign_key: true,
      null: false,
      default: 0

    drop_join_table :work_spaces, :polling_stations
  end
end
