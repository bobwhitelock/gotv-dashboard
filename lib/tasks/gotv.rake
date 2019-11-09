# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

require './lib/imports.rb'
require 'open-uri'

def wheredoivote_data(endpoint)
  endpoint_url = "https://wheredoivote.co.uk/api/beta/#{endpoint}.json"
  data = open(endpoint_url).read
  return JSON.parse(data)
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

  desc 'Generate plausible random Labour promises and registered voters for all work space polling stations'
  task randomize_figures: :environment do
    WorkSpacePollingStation.all.each do |ps|
      registered_voters = rand(500..3000)
      ps.pre_election_registered_voters = registered_voters

      minimum_promises = registered_voters / 3
      maximum_promises = registered_voters * 2/3
      ps.pre_election_labour_promises = rand(minimum_promises..maximum_promises)

      ps.save!
    end
  end
end
