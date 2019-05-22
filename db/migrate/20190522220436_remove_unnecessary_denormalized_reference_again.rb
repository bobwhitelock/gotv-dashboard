class RemoveUnnecessaryDenormalizedReferenceAgain < ActiveRecord::Migration[5.2]
  def change
    remove_reference :polling_stations, :council
  end
end
