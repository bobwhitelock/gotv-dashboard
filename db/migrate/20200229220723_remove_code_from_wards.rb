class RemoveCodeFromWards < ActiveRecord::Migration[5.2]
  def change
    remove_column :wards, :code, :string, null: false, default: ''
  end
end
