# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


require 'postcodes_io'

def find_polling_stations(council_code)
  endpoint_url = "https://wheredoivote.co.uk/api/beta/pollingstations.json?council_id=#{council_code}"
  stations = JSON.parse(open(endpoint_url).read)
  stations.map do |station|
    # some of the postcode fields are missing so scrape from address. credit https://www.regextester.com/93715
    postcode_regex = /\b((?:(?:gir)|(?:[a-pr-uwyz])(?:(?:[0-9](?:[a-hjkpstuw]|[0-9])?)|(?:[a-hk-y][0-9](?:[0-9]|[abehmnprv-y])?)))) ?([0-9][abd-hjlnp-uw-z]{2})\b/i
    station['postcode'] = station['address'][postcode_regex]
    station['council_code'] = council_code
    station
  end
end

def find_administrative_areas(postcodes)
  pio = Postcodes::IO.new
  no_detail_by_default = Hash.new
  pio.lookup(postcodes).each_with_object(Hash.new(no_detail_by_default)) do |result, memo|
    # a couple of postcode don't seem to be found eg YO1 0RL and Y01 9TL (note zero)
    unless result.info.nil?
      memo[result.postcode] = {
          :ward_code => result.codes['admin_ward'],
          :ward_name => result.admin_ward,
          :parliamentary_constituency_code => result.codes['parliamentary_constituency'],
          :parliamentary_constituency_name => result.parliamentary_constituency,
      }
    end
  end
end


def add_administrative_areas(stations)
  good_postcodes = stations.map {|station| station['postcode']}.compact # eg '2nd Haxby & Wigginton Scout HQ, 9 York Road, Haxby', 'Mobile Unit, White Swan car park, York Road, Deighton' or 'Y032 9FY' (note zero instead of O)
  administrative_areas_hash = find_administrative_areas(good_postcodes)
  stations.map { |station| station.merge( administrative_areas_hash[station['postcode']]) }
end


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




