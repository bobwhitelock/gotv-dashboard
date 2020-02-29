class EliminateCouncils < ActiveRecord::Migration[5.2]
  # This migration expects no data to exist in database; will probably break or
  # do unexpected things if data does exist.
  def change
    remove_reference :wards, :council

    drop_table :councils, force: :cascade do |t|
      t.string "name", null: false
      t.string "code", null: false
      t.boolean "transient", default: false, null: false
    end
  end
end
