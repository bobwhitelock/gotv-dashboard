class TightenUpDataIntegrity < ActiveRecord::Migration[5.2]
  def change
    change_column_null :polling_stations, :reference, false, ''
    change_column_null :polling_stations, :ward_id, false

    change_column_null :wards, :name, false, ''
    change_column_null :wards, :code, false, ''

    change_column_null :councils, :name, false, ''
    change_column_null :councils, :code, false, ''
  end
end
