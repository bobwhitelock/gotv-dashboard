
ContactCreatorImporter = Struct.new(
  :work_space_name,
  :polling_stations_csv,
  :campaign_stats_csv
) do
  def self.import(work_space_name:, polling_stations_csv:, campaign_stats_csv:)
    new(work_space_name, polling_stations_csv, campaign_stats_csv).import
  end

  def import
    ActiveRecord::Base.transaction do
      work_space = WorkSpace.create!(name: work_space_name)
      transient_council = create_council

      # First 4 lines are not useful, headers do not have useful values,
      # therefore drop these lines.
      csv_lines = campaign_stats_csv.lines
      campaign_stats_csv = csv_lines.slice(4, csv_lines.length).join

      district_to_campaign_stats = CSV.parse(campaign_stats_csv).map do |district_row|
        [district_row[1], district_row]
      end.to_h

      CSV.parse(polling_stations_csv, headers: true) do |station_row|
        ward = maybe_create_ward(transient_council, station_row)
        polling_district = maybe_create_polling_district(ward, station_row)
        polling_station = create_polling_station(polling_district, station_row)

        district_row = district_to_campaign_stats[polling_district.reference]
        create_work_space_polling_station(work_space, polling_station, station_row, district_row)
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

  def maybe_create_polling_district(ward, station_row)
    polling_district = PollingDistrict.find_or_create_by!(
      ward: ward,
      reference: station_row.fetch('polling_district')
    )
    debug "Created PollingDistrict: #{polling_district.reference}"
    polling_district
  end

  def create_polling_station(polling_district, station_row)
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
      polling_district: polling_district
    )
    debug "Created PollingStation: #{polling_station.name} - box: #{polling_station.reference}"
    polling_station
  end

  def create_work_space_polling_station(work_space, polling_station, station_row, district_row)
    wsps = WorkSpacePollingStation.create!(
      work_space: work_space,
      polling_station: polling_station,
      # These will be updated below, iff this is the proxy
      # WorkSpacePollingStation for this PollingDistrict. XXX Need to improve
      # the data model related to this at some point - see
      # https://github.com/bobwhitelock/gotv-dashboard/issues/100.
      box_electors: 0,
      postal_electors: 0,
      box_labour_promises: 0,
      postal_labour_promises: 0
    )

    if wsps.work_space_polling_district_proxy?
      # XXX Possibly should import and use other campaign stats fields?

      total_electors = parse_campaign_stats_int(district_row[2])
      postal_electors = parse_campaign_stats_int(district_row[9])
      box_electors = total_electors - postal_electors

      total_labour_promises = parse_campaign_stats_int(district_row[4])
      postal_labour_promises = parse_campaign_stats_int(district_row[12])
      box_labour_promises = total_labour_promises - postal_labour_promises

      wsps.update!(
        box_electors: box_electors,
        postal_electors: postal_electors,
        box_labour_promises: box_labour_promises,
        postal_labour_promises: postal_labour_promises
      )
    end

    debug "Created WorkSpacePollingStation: #{wsps.name} - box: #{wsps.reference}"
  end

  def parse_campaign_stats_int(value)
    value.gsub(',', '').to_i
  end

  def debug(*args)
    STDERR.puts(*args)
  end

  def url_helpers
    Rails.application.routes.url_helpers
  end
end
