class AssociatePollingDistrictWithCommitteeRoom < ActiveRecord::Migration[5.2]
  def change
    remove_reference :polling_stations, :committee_room
    add_reference :polling_districts, :committee_room
  end
end
