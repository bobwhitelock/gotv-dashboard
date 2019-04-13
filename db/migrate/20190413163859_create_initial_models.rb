class CreateInitialModels < ActiveRecord::Migration[5.2]
  def change
    create_table :work_spaces do |t|
      t.string :name, null: false

      t.timestamps null: false
    end

    create_table :polling_stations do |t|
      t.string :name, null: false
      t.integer :pre_election_registered_voters, null: false
      t.integer :pre_election_labour_promises, null: false
      t.references :work_space, null: false, foreign_key: true

      t.timestamps null: false
    end

    create_table :turnout_observations do |t|
      t.integer :count, null: false
      t.references :polling_station, null: false, foreign_key: true

      t.timestamps null: false
    end

    create_table :confirmed_labour_voters_observations do |t|
      t.integer :count, null: false
      t.references :polling_station, null: false, foreign_key: true,
        # Because default index name is too long.
        index: {name: 'index_clvo_on_polling_station_id'}

      t.timestamps null: false
    end
  end
end
