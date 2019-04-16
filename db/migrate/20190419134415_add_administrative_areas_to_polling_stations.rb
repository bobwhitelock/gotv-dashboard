class AddAdministrativeAreasToPollingStations < ActiveRecord::Migration[5.2]
  def change
    create_table :wards do |t|
      t.string :name
      t.string :code
    end

    create_table :councils do |t|
      t.string :name
      t.string :code
    end

    add_column :polling_stations, :postcode, :string

    add_reference :polling_stations, :ward, foreign_key: true
    add_reference :polling_stations, :council, foreign_key: true
    add_reference :wards, :council, foreign_key: true
  end
end
