# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require './lib/imports.rb'


namespace :gotv do
  desc "import councils"
  task import_councils: :environment do
    councils = JSON.parse(open("https://wheredoivote.co.uk/api/beta/councils.json").read)
                   .map {|council| {:code => council['council_id'], :name => council['name']}}
    councils.each {|council| Council.create!(council)}
  end


  desc "Import Redbridge stations"
  task import_redbridge: :environment do
    require 'csv'
    redbridge_council_code = 'E09000026'

    stations = []
    CSV.foreach('lib/assets/redbridge-stations-extract-cleaned.csv', :headers => true) do |row|
      stations << {
          # 'name' => row['Polling Place'],
          'address' => row['Polling Place'],
          'postcode' => row['Polling Place'][POSTCODE_REGEX],
          # 'district_references' => row['Polling Districts'].delete(' ').split(',')
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
            council_id: council_id,
            pre_election_registered_voters: 0,
            pre_election_labour_promises: 0
        )
      else
        puts "Couldn't find ward for " + station['address']
      end
    end

  end

end
