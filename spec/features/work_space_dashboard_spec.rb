require 'rails_helper'

RSpec.feature 'work space dashboard', type: :feature, js: true do
  it 'displays all polling stations, with key stats' do
    polling_station = create(
      :work_space_polling_station,
      work_space: create(:work_space),
      polling_station: create(
        :polling_station,
        name: 'Some Polling Station',
        reference: 'SPS-123',
        polling_district: create(
          :polling_district,
          reference: 'PD',
          ward: create(:ward, name: 'My Ward')
        )
      ),
      box_electors: 200,
      box_labour_promises: 100,
      postal_labour_promises: 20,
      postal_electors: 60
    )

    visit work_space_path(polling_station.work_space)

    expect(page).to have_text('Some Polling Station')
    expect(page).to have_text('MY WARD | PD | SPS-123')
    expect(page).to have_text('100 promises / 200 box voters')
    expect(page).to have_text('20 promises / 60 postal voters')
    expect(page).to have_text('0 (not yet observed)')
  end
end
