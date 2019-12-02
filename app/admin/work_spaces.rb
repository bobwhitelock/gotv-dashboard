
ActiveAdmin.register WorkSpace do
  controller do
    resources_configuration[:self][:finder] = :find_by_identifier
  end

  index do
    # Need to inline all column definitions in order to customize.
    selectable_column
    id_column
    column :name
    column :created_at
    column :updated_at
    column :identifier

    actions do |work_space|
      item 'View Dashboard', work_space_path(work_space)
    end
  end

  action_item :view, only: :show do
    link_to 'View Dashboard', work_space_path(resource)
  end
end
