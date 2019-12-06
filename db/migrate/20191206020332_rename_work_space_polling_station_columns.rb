class RenameWorkSpacePollingStationColumns < ActiveRecord::Migration[5.2]
  def change
    # Renaming these to be more accurate (and concise), as they will just be
    # the box electors/promises for the polling station, and will not include
    # postal voters.
    rename_column :work_space_polling_stations,
      :pre_election_registered_voters,
      :box_electors
    rename_column :work_space_polling_stations,
      :pre_election_labour_promises,
      :box_labour_promises
  end
end
