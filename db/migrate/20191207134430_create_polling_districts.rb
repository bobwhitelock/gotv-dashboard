class CreatePollingDistricts < ActiveRecord::Migration[5.2]
  def change
    create_table :polling_districts do |t|
      t.references :ward, null: false, foreign_key: true
      t.string :reference, null: false

      t.timestamps null: false
    end

    change_column_null :polling_stations, :ward_id, true
    add_reference :polling_stations, :polling_district, foreign_key: true
  end
end
