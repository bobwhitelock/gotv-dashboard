class MoveElectorsAndPromisesToPollingDistrict < ActiveRecord::Migration[5.2]
  # This migration expects no data to exist in database; will probably break or
  # do unexpected things if data does exist.
  def change
    [
      :box_electors,
      :box_labour_promises,
      :postal_electors,
      :postal_labour_promises
    ].each do |column|
      remove_column :polling_stations, column, :integer, null: false, default: 0
      add_column :polling_districts, column, :integer
      change_column_null :polling_districts, column, false
    end
  end
end
