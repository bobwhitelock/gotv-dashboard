ContactCreatorImporter = Struct.new(
  :work_space_name,
  :polling_stations_path
) do
  def self.import(work_space_name:, polling_stations_path:)
    new(work_space_name, polling_stations_path).import
  end

  def import
    ActiveRecord::Base.transaction do
      work_space = WorkSpace.create!(name: work_space_name)
      transient_council = create_council

      CSV.foreach(polling_stations_path, headers: true) do |station_row|
        ward = maybe_create_ward(transient_council, station_row)
        polling_station = create_polling_station(ward, station_row)
        create_work_space_polling_station(work_space, polling_station, station_row)
      end

      work_space_url = url_helpers.work_space_url(work_space.identifier)
      puts "\nURL for new work space: #{work_space_url}"
    end
  end

  private

  def create_council
    council = Council.create!(
      name: "#{work_space_name} [transient council]",
      code: 'transient'
    )
    debug "Created Council: #{council.name} (id: #{council.id})"
    council
  end

  def maybe_create_ward(transient_council, station_row)
    Ward.find_or_create_by!(
      council: transient_council,
      name: station_row.fetch('ward')
    ) do |w|
      w.code = 'transient'
      debug "Created Ward: #{w.name}"
    end
  end

  def create_polling_station(ward, station_row)
    postcode = station_row.fetch('polling_place_postcode')

    polling_station_name = [
      station_row.fetch('polling_place_name'),
      station_row.fetch('polling_place_address'),
      postcode
    ].join(', ')

    polling_station = PollingStation.create!(
      name: polling_station_name,
      postcode: postcode,
      reference: station_row.fetch('ballot_box_number'),
      # Not actually used for anything at the moment but might as well extract
      # since it's here.
      polling_district: station_row.fetch('polling_district'),
      ward: ward
    )
    debug "Created PollingStation: #{polling_station.name} - box: #{polling_station.reference}"
    polling_station
  end

  def create_work_space_polling_station(work_space, polling_station, station_row)
    # XXX Also associate postal voters with this
    wsps = WorkSpacePollingStation.create!(
      work_space: work_space,
      polling_station: polling_station,
      box_electors: station_row['count_of_box_electors'],
      # XXX Change this to import real value
      box_labour_promises: 0
    )
    debug "Created WorkSpacePollingStation: #{wsps.name} - box: #{wsps.reference}"
  end

  def debug(*args)
    STDERR.puts(*args)
  end

  def url_helpers
    Rails.application.routes.url_helpers
  end
end
