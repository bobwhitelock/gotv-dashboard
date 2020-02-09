# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

require './lib/imports.rb'
require 'open-uri'

def wheredoivote_data(endpoint)
  endpoint_url = "https://wheredoivote.co.uk/api/beta/#{endpoint}.json"
  data = open(endpoint_url).read
  return JSON.parse(data)
end

def env_param(param_name)
  param = ENV[param_name]
  unless param
    abort "ERROR: Expected `#{param_name}=VALUE` to be passed"
  end
  param
end

def observation_attributes(observation)
  notes = nil
  valid = true

  case observation
  when TurnoutObservation
    type = 'Turnout'
    level = 'Polling Station'
  when WarpCountObservation
    type = 'WARP Count'
    level = 'Polling District'
    notes = observation.notes
    valid = observation.is_valid
  when CanvassersObservation
    type = 'Canvassers'
    level = 'Committee Room'
  when CarsObservation
    type = 'Cars'
    level = 'Committee Room'
  when RemainingLiftsObservation
    type = 'Remaining Lifts'
    level = 'Polling District'
  else
    abort "ERROR: Unhandled observation type: #{observation.class}"
  end

  location = observation_location_for_level(
    observation: observation, level: level
  )

  OpenStruct.new(
    type: type,
    level: level,
    notes: notes,
    valid: valid,
    location: location,
    time: observation.created_at.iso8601,
    user: observation.user&.name,
    count: observation.count
  )
end

def observation_location_for_level(observation:, level:)
  case level
  when 'Polling Station'
    observation.work_space_polling_station.fully_specified_name
  when 'Polling District'
    observation.work_space_polling_station.polling_district.fully_specified_name
  when 'Committee Room'
    observation.committee_room.address
  else
    abort "ERROR: Unhandled observation level: #{level}"
  end
end

namespace :gotv do
  desc 'Import all councils from wheredoivote.co.uk'
  task import_councils: :environment do
    # Some items returned from this URL lack names for some reason; ignore
    # these.
    councils = wheredoivote_data('councils')
      .reject {|c| c['name'].empty?}
      .map do |council|
      {
        code: council['council_id'],
        name: council['name']
      }
    end

    councils.each { |council| Council.create!(council) }
  end


  desc 'Import Redbridge wards and polling stations from local CSV file'
  task import_redbridge: :environment do
    require 'csv'
    redbridge_council_code = 'E09000026'

    stations = []
    CSV.foreach('lib/assets/redbridge-stations-extract-cleaned.csv', :headers => true) do |row|
      stations << {
          # 'name' => row['Polling Place'],
          'address' => row['Polling Place'],
          'postcode' => row['Polling Place'][POSTCODE_REGEX],
          # XXX These are not necessarily accurate; polling place could contain
          # boxes from different areas
          'reference' => row['Reference'],
          'polling_district' => row['Polling Districts'],
      }
    end

    council_id = Council.find_by(code: redbridge_council_code).id
    stations = add_administrative_areas(stations)

    wards = stations
                .uniq {|station| station[:ward_code]}
                .select {|w| w[:ward_code] != 'unknown'}
                .map {|ward| {
                    :code => ward[:ward_code],
                    :name => ward[:ward_name],
                    :council_id => council_id
                }}

    wards.each {|ward| Ward.create!(ward)}

    stations.each do |station|
      ward = Ward.find_by(code: station[:ward_code])
      if ward
        PollingStation.create!(
            name: station['address'],
            postcode: station['postcode'],
            ward: ward,
            reference: station['reference'],
            polling_district: station['polling_district'],
        )
      else
        puts "Couldn't find ward for " + station['address']
      end
    end

  end

  desc 'Import data exported from Contact Creator and create WorkSpace'
  task import_contact_creator: :environment do
    work_space_name = env_param('name')
    polling_stations_url = env_param('polling_stations')
    campaign_stats_url = env_param('campaign_stats')

    ContactCreatorImporter.import(
      work_space_name: work_space_name,
      polling_stations_csv: open(polling_stations_url).read,
      campaign_stats_csv: open(campaign_stats_url).read
    )
  end

  desc 'Generate plausible random Labour promises and registered voters for all workspace polling stations'
  task randomize_figures: :environment do
    WorkSpacePollingStation.all.each do |ps|
      box_electors = rand(500..3000)
      ps.box_electors = box_electors

      minimum_promises = box_electors / 3
      maximum_promises = box_electors * 2/3
      ps.box_labour_promises = rand(minimum_promises..maximum_promises)

      ps.save!
    end
  end

  desc 'Export all observations for a WorkSpace as CSV to STDOUT'
  task export_workspace: :environment do
    identifier = env_param('identifier')
    work_space = WorkSpace.find_by!(identifier: identifier)

    headers = [
      'Observation Type',
      'Observation Level',
      'Time',
      'User',
      'Location',
      'Count',
      'Notes',
      'Valid'
    ]

    observations_csv = CSV.generate(headers: headers, write_headers: true) do |csv|
      work_space.all_observations.each do |o|
        attrs = observation_attributes(o)

        csv << [
          attrs.type,
          attrs.level,
          attrs.time,
          attrs.user,
          attrs.location,
          attrs.count,
          attrs.notes,
          attrs.valid
        ]
      end
    end

    puts observations_csv
  end
end
