class CreateJoinTableWorkSpacePollingStation < ActiveRecord::Migration[5.2]
  def change
    create_join_table :work_spaces, :polling_stations do |t|
      # t.index [:work_space_id, :polling_station_id]
      # t.index [:polling_station_id, :work_space_id]
    end
  end
end
