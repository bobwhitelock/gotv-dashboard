ContactCreatorImporter = Struct.new(
  :work_space_name,
  :polling_stations_path
) do
  def self.import(work_space_name:, polling_stations_path:)
    new(work_space_name, polling_stations_path).import
  end

  def import
    work_space = WorkSpace.create!(name: work_space_name)

    puts "\nURL for new work space: #{Rails.application.routes.url_helpers.work_space_url(work_space.identifier)}"
  end
end
