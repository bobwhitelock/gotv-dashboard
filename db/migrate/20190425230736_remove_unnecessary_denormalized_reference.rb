class RemoveUnnecessaryDenormalizedReference < ActiveRecord::Migration[5.2]
  def change
    remove_reference :polling_stations, :councils
  end
end
