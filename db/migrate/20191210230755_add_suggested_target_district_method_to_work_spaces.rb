class AddSuggestedTargetDistrictMethodToWorkSpaces < ActiveRecord::Migration[5.2]
  def change
    add_column :work_spaces,
      :suggested_target_district_method,
      :text,
      null: false,
      default: 'estimates'
  end
end
