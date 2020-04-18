class MergePollingStationAndWorkSpacePollingStation < ActiveRecord::Migration[5.2]
  # This migration expects no data to exist in database; will probably break or
  # do unexpected things if data does exist.
  def change
    # Remove old references from observations to WSPS.
    [
      :turnout_observations,
      :warp_count_observations
    ].each do |table|
      remove_reference table,
        :work_space_polling_station,
        null: false,
        default: 0
    end
    remove_reference :remaining_lifts_observations,
      :work_space_polling_station,
      null: false,
      # Because default index name is too long.
      index: { name: 'index_rlo_on_work_space_polling_station_id' },
      default: 0

    # Eliminate WSPS.
    drop_table :work_space_polling_stations, force: :cascade do |t|
      t.integer 'polling_station_id', null: false
      t.integer 'work_space_id', null: false
      t.integer 'box_electors', null: false
      t.integer 'box_labour_promises', null: false
      t.datetime 'created_at', null: false
      t.datetime 'updated_at', null: false
      t.integer 'committee_room_id'
      t.integer 'postal_labour_promises', default: 0, null: false
      t.integer 'postal_electors', default: 0, null: false
      t.index ['committee_room_id'],
        name: 'index_work_space_polling_stations_on_committee_room_id'
      t.index ['polling_station_id'],
        name: 'index_work_space_polling_stations_on_polling_station_id'
      t.index ['work_space_id'],
        name: 'index_work_space_polling_stations_on_work_space_id'
    end

    # Associate observations with new correct tables.
    add_reference :turnout_observations, :polling_station
    change_column_null :turnout_observations, :polling_station_id, false
    [
      :warp_count_observations,
      :remaining_lifts_observations
    ].each do |table|
      add_reference table, :polling_district
      change_column_null table, :polling_district_id, false
    end

    # Add everything which used to be on WSPS to PollingStations
    change_table :polling_stations do |t|
      t.integer 'box_electors'
      t.integer 'box_labour_promises'
      t.integer 'postal_labour_promises'
      t.integer 'postal_electors'
    end
    add_reference :polling_stations, :work_space
    add_reference :polling_stations, :committee_room
    [
      :box_electors,
      :box_labour_promises,
      :postal_labour_promises,
      :postal_electors,
      :work_space_id
    ].each do |column|
      change_column_null :polling_stations, column, false
    end
  end
end
