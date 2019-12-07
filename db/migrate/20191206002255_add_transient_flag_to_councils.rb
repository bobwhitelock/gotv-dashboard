class AddTransientFlagToCouncils < ActiveRecord::Migration[5.2]
  def change
    add_column :councils, :transient, :boolean, null: false, default: false
  end
end
