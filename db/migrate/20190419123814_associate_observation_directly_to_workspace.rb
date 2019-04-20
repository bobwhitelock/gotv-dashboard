class AssociateObservationDirectlyToWorkspace < ActiveRecord::Migration[5.2]
  def change
    add_reference :turnout_observations, :work_spaces, foreign_key: true
    # remove_foreign_key :polling_stations, name: :work_space
    remove_column :polling_stations, :work_space_id, :integer
  end
end
