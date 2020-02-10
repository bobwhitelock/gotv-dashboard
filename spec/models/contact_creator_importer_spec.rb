require 'rails_helper'

RSpec.describe ContactCreatorImporter, type: :model do
  # XXX Make this test not output to STDOUT/STDERR.
  it 'correctly creates work space from given Contact Creator data' do
    polling_stations_csv = File.read('example_data/polling_stations.csv')
    campaign_stats_csv = File.read('example_data/campaign_stats.csv')

    work_space = ContactCreatorImporter.import(
      work_space_name: 'Test Work Space',
      polling_stations_csv: polling_stations_csv,
      campaign_stats_csv: campaign_stats_csv
    )

    expect(work_space.name).to eq('Test Work Space')
    wards = work_space.wards
    expect(wards.length).to eq(8)
    expect(wards.first.name).to eq('BISHOPS')
    districts = work_space.polling_districts
    expect(districts.length).to eq(36)
    first_district = districts.first
    expect(first_district.reference).to eq('VAA')
    stations = work_space.work_space_polling_stations
    expect(stations.length).to eq(51)
    first_station = stations.first
    expect(first_station.reference).to eq('51') # (coincidentally same as above)
    expect(first_station.name).to eq(
      'New Cut Housing Co-operative Community Room, 106 The Cut, SE1 8LN'
    )
    expect(first_station.postcode).to eq('SE1 8LN')
    expect(first_station.polling_district).to eq(first_district)
    expected_total_electors = 1717
    expected_postal_electors = 74
    expected_total_promises = 710
    expected_postal_promises = 40
    expect(first_station.box_electors).to eq(
      expected_total_electors - expected_postal_electors
    )
    expect(first_station.postal_electors).to eq(expected_postal_electors)
    expect(first_station.box_labour_promises).to eq(
      expected_total_promises - expected_postal_promises
    )
    expect(first_station.postal_labour_promises).to eq(expected_postal_promises)
  end
end
