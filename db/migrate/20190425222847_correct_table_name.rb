class CorrectTableName < ActiveRecord::Migration[5.2]
  def change
    rename_table 'confirmed_labour_voters_observations', 'confirmed_labour_voter_observations'
  end
end
