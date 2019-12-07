class MakePollingStationPollingDistrictRelationNonNull < ActiveRecord::Migration[5.2]
  def change
    change_column_null :polling_stations, :polling_district_id, false
  end
end
