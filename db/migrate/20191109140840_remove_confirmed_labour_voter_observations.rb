class RemoveConfirmedLabourVoterObservations < ActiveRecord::Migration[5.2]
  def change
    drop_table :confirmed_labour_voter_observations
  end
end
