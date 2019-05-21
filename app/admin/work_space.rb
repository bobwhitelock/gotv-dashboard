
ActiveAdmin.register WorkSpace do
  controller do
    resources_configuration[:self][:finder] = :find_by_identifier
  end
end
