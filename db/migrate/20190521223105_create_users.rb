class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.text :name
      t.text :phone_number

      t.timestamps null: false
    end

    add_reference :turnout_observations, :user, foreign_key: true
  end
end
