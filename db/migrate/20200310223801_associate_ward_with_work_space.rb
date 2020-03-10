class AssociateWardWithWorkSpace < ActiveRecord::Migration[5.2]
  def change
    change_column_null :polling_stations, :work_space_id, true
    remove_reference :polling_stations, :work_space
    add_reference :wards, :work_space
    change_column_null :wards, :work_space_id, false
  end
end
