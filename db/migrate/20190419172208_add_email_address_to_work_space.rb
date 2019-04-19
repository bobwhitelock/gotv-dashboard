class AddEmailAddressToWorkSpace < ActiveRecord::Migration[5.2]
  def change
    add_column :work_spaces, :email, :string
  end
end
