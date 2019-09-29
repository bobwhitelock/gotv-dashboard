# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require './lib/imports.rb'


# XXX Currently just finding polling stations for 1 council (this is
# Canterbury) - update to find all.
stations = find_polling_stations('E07000106').compact
if stations.empty?
  abort "No polling stations found - check #{__FILE__}"
end
puts stations.length
stations = add_administrative_areas(stations)


puts stations
         .map { |station| station[:ward_code] }


councils = JSON.parse(open("https://wheredoivote.co.uk/api/beta/councils.json").read)
            .map { |council| { :code => council['council_id'], :name => council['name']} }
councils.each{|council| Council.create!(council)}



wards = stations
            .uniq { |station| station[:ward_code] }
            .map do |ward|
              {
                  :code => ward[:ward_code],
                  :name => ward[:ward_name],
                  :council_id => Council.find_by(code: ward['council_code']).id
              }
            end

wards.each{|ward| Ward.create!(ward)}

stations.each do |station|
  PollingStation.create!(
      name: station['address'],
      postcode: station['postcode'],
      ward: Ward.find_by(code: station[:ward_code]),
      pre_election_registered_voters: 0,
      pre_election_labour_promises: 0
  )
end
