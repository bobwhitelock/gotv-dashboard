require 'rails_helper'

RSpec.feature 'raw data page', type: :feature, js: true do
  it 'shows all past turnout observations' do
    work_space = create(:work_space)
    create(
      :turnout_observation,
      count: 42,
      user: create(:user, name: 'Some Campaigner', phone_number: '555 123'),
      polling_station: create(
        :polling_station,
        name: 'First Polling Station',
        polling_district: create(
          :polling_district, ward: create(
            :ward, work_space: work_space
          )
        )
      )
    )
    create(
      :turnout_observation,
      count: 66,
      polling_station: create(
        :polling_station,
        name: 'Second Polling Station',
        polling_district: create(
          :polling_district, ward: create(
            :ward, work_space: work_space
          )
        )
      )
    )

    visit work_space_turnout_observations_path(work_space)

    expect(page).to have_text('First Polling Station')
    expect(page).to have_text('42')
    expect(page).to have_text('Some Campaigner')
    expect(page).to have_text('Second Polling Station')
    expect(page).to have_text('66')
  end

  # XXX This test fails without network access due to failure to load
  # FontAwesome - make this more robust.
  it 'allows creating new observation with amended count for past observation', unstable: true do
    observation = create(:turnout_observation, count: 42)

    visit work_space_turnout_observations_path(observation.work_space)
    find_data_test('amend-count-button').click
    fill_in 'What is the correct ballot count?', with: 43
    click_on 'Amend count'

    expect(page).to have_text('43')
    expect(find_data_test('past-counts-list')).to have_text('42')
  end
end
