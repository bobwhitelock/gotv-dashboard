class RemoveUnnecessaryDenormalizedReference < ActiveRecord::Migration[5.2]
  def change
    # Disabled in favour of
    # `db/migrate/20190522220436_remove_unnecessary_denormalized_reference_again.rb`;
    # was erroring in Postgres (but not locally in Sqlite) due to typo in
    # `councils`.
    # remove_reference :polling_stations, :councils
  end
end
