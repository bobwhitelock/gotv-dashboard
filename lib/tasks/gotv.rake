require 'open-uri'

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
    observation.polling_station.fully_specified_name
  when 'Polling District'
    observation.polling_station.polling_district.fully_specified_name
  when 'Committee Room'
    observation.committee_room.address
  else
    abort "ERROR: Unhandled observation level: #{level}"
  end
end

namespace :gotv do
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

  # XXX Add test coverage for this task (maybe by extracting object for core
  # behaviour, like ContactCreatorImporter).
  desc 'Sanitize data files exported from Contact Creator, ready to be used by `gotv:import_contact_creator`'
  task sanitize_contact_creator_data: :environment do
    polling_stations_file = env_param('polling_stations')
    campaign_stats_file = env_param('campaign_stats')

    polling_stations = File.read(polling_stations_file)
    campaign_stats = File.read(campaign_stats_file)

    sanitized_polling_stations = CSV.generate do |new_csv|
      headers = CSV.parse_line(polling_stations)
      new_csv << headers

      CSV.parse(polling_stations, headers: true) do |row|

        # Just blank sensitive numerical columns.
        row['count_of_box_electors'] = 0
        row['count_of_postal_electors'] = 0
        row['minimum_polling_number'] = 0
        row['maximum_polling_number'] = 0

        new_csv << row
      end
    end

    sanitized_campaign_stats = CSV.generate do |new_csv|
      current_csv_lines = campaign_stats.lines

      # First 4 lines have different format, are not useful, therefore append
      # them unchanged and do not consider them below.
      current_csv_lines.slice(0, 4).each do |row|
        new_csv << CSV.parse_line(row)
      end

      campaign_stats_csv = current_csv_lines.slice(4, current_csv_lines.length).join
      CSV.parse(campaign_stats_csv) do |row|
        # Blank all numerical columns by default.
        (2..row.length).each do |column|
          row[column] = 0
        end

        # Create random figures for columns we need (total/postal
        # electors/promises).
        total_electors = rand(500..3000)
        minimum_total_promises = total_electors / 3
        maximum_total_promises = total_electors * 2/3
        total_labour_promises = rand(minimum_total_promises..maximum_total_promises)

        postal_electors = rand(50..200)
        minimum_postal_promises = postal_electors / 3
        maximum_postal_promises = postal_electors * 2/3
        postal_labour_promises = rand(minimum_postal_promises..maximum_postal_promises)

        # Only total electors column is formatted as string for some reason
        # (like `1717` => `"1,717"`), therefore add back this formatting to new
        # sanitized value.
        formatted_total_electors_chars = []
        digits = total_electors.to_s.chars
        digits.reverse.each_with_index do |digit, index|
          formatted_total_electors_chars << digit
          position = index + 1
          if (position % 3).zero? && position != digits.length
            formatted_total_electors_chars << ','
          end
        end
        formatted_total_electors = formatted_total_electors_chars.reverse.join

        row[2] = formatted_total_electors
        row[9] = postal_electors
        row[4] = total_labour_promises
        row[12] = postal_labour_promises

        new_csv << row
      end
    end

    File.write(polling_stations_file, sanitized_polling_stations)
    File.write(campaign_stats_file, sanitized_campaign_stats)
  end

  # XXX Add test coverage for this task (maybe by extracting object for core
  # behaviour, like ContactCreatorImporter).
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
