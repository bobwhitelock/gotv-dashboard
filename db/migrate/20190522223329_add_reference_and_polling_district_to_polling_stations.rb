class AddReferenceAndPollingDistrictToPollingStations < ActiveRecord::Migration[5.2]
  def change
    add_column :polling_stations, :reference, :string
    add_column :polling_stations, :polling_district, :string
  end
end
