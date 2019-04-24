class AddIdentifierToWorkSpaces < ActiveRecord::Migration[5.2]
  def up
    add_column :work_spaces, :identifier, :string, unique: true

    # Backfill existing WorkSpaces.
    WorkSpace.all.each do |ws|
      ws.send(:create_identifier)
      ws.save!
    end

    change_column :work_spaces, :identifier, :string, unique: true, null: false
  end

  def down
    remove_column :work_spaces, :identifier
  end
end
