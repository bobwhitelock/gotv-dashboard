class AddPostalElectorFieldsToWorkSpacePollingStations < ActiveRecord::Migration[5.2]
  def change
    add_column :work_space_polling_stations,
      :postal_labour_promises,
      :integer,
      null: false,
      default: 0
    add_column :work_space_polling_stations,
      :postal_electors,
      :integer,
      null: false,
      default: 0
  end
end
