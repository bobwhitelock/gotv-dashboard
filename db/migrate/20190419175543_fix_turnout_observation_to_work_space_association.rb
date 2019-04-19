class FixTurnoutObservationToWorkSpaceAssociation < ActiveRecord::Migration[5.2]
  def change
    rename_column :turnout_observations, :work_spaces_id, :work_space_id
  end
end
