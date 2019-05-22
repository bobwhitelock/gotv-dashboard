require 'postcodes_io'

# some of the postcode fields are missing so scrape from address. credit https://www.regextester.com/93715
POSTCODE_REGEX = /\b((?:(?:gir)|(?:[a-pr-uwyz])(?:(?:[0-9](?:[a-hjkpstuw]|[0-9])?)|(?:[a-hk-y][0-9](?:[0-9]|[abehmnprv-y])?)))) ?([0-9][abd-hjlnp-uw-z]{2})\b/i


def find_polling_stations(council_code)
  endpoint_url = "https://wheredoivote.co.uk/api/beta/pollingstations.json?council_id=#{council_code}"
  stations = JSON.parse(open(endpoint_url).read)
  stations.map do |station|
    station['postcode'] = station['address'][POSTCODE_REGEX]
    station['council_code'] = council_code
    station
  end
end

def find_administrative_areas(postcodes)
  no_detail_by_default = Hash.new
  memo = Hash.new(no_detail_by_default)

  max_allowed_by_postcodes_io = 100
  postcodes.each_slice(max_allowed_by_postcodes_io).to_a.map do |batch|
    pio = Postcodes::IO.new

    pio.lookup(batch).each do |result|
      # a couple of postcode don't seem to be found eg YO1 0RL and Y01 9TL (note zero)
      unless result.info.nil?
        ward_code = result.codes['admin_ward']
        ward_name = result.admin_ward
        constituency_code = result.codes['parliamentary_constituency']
        constituency_name = result.parliamentary_constituency
        memo[result.postcode] = {
            ward_code: ward_code,
            ward_name: ward_name,
            parliamentary_constituency_code: constituency_code,
            parliamentary_constituency_name: constituency_name,
        }
      end
    end
  end
  memo
end


def add_administrative_areas(stations)
  good_postcodes = stations.map {|station| station['postcode']}.compact # eg '2nd Haxby & Wigginton Scout HQ, 9 York Road, Haxby', 'Mobile Unit, White Swan car park, York Road, Deighton' or 'Y032 9FY' (note zero instead of O)
  # puts good_postcodes
  administrative_areas_hash = find_administrative_areas(good_postcodes)
  stations.map do |station|
    # Can't find the area for some stations (possibly due to postcode issue
    # above?) so just associate these with a placeholder 'Unknown Ward' - XXX
    # handle this better
    area = administrative_areas_hash.fetch(station['postcode'], unknown_ward)
    station.merge(area)
  end
end

def unknown_ward
  {
      ward_code: 'unknown',
      ward_name: 'Unknown Ward',
      parliamentary_constituency_code: 'unknown',
      parliamentary_constituency_name: 'Unknown Constituency',
  }
end