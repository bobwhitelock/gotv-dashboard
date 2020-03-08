require 'rails_helper'

RSpec.feature 'work space configuration', type: :feature do
  it 'allows setting promises and voters for all polling districts' do
    polling_district = create(
      :polling_district,
      box_electors: 0,
      box_labour_promises: 0
    )
    # XXX Only needed as WorkSpace related directly to PollingStations
    create(:polling_station, polling_district: polling_district)

    visit work_space_configuration_path(polling_district.work_space)
    find_data_test('registered-voters-field').fill_in(with: 50)
    find_data_test('labour-promises-field').fill_in(with: 30)
    click_on 'Save workspace figures'

    polling_district.reload
    expect(polling_district.box_electors).to eq(50)
    expect(polling_district.box_labour_promises).to eq(30)
  end
end
