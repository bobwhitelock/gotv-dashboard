require 'rails_helper'

RSpec.feature 'work space configuration', type: :feature do
  it 'allows setting promises and voters for all work space polling stations' do
    polling_station = create(
      :polling_station,
      box_electors: 0,
      box_labour_promises: 0
    )

    visit work_space_configuration_path(polling_station.work_space)
    find_data_test('registered-voters-field').fill_in(with: 50)
    find_data_test('labour-promises-field').fill_in(with: 30)
    click_on 'Save workspace figures'

    polling_station.reload
    expect(polling_station.box_electors).to eq(50)
    expect(polling_station.box_labour_promises).to eq(30)
  end
end
