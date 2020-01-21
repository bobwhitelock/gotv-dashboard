require 'rails_helper'

RSpec.feature 'raw data page', type: :feature, js: true do
  it 'shows all past turnout observations' do
    work_space = create(:work_space)
    create(
      :turnout_observation,
      count: 42,
      work_space: work_space,
      user: create(:user, name: 'Some Campaigner', phone_number: '555 123'),
      work_space_polling_station: create(
        :work_space_polling_station,
        polling_station: create(
          :polling_station, name: 'First Polling Station'
        )
      )
    )
    create(
      :turnout_observation,
      count: 66,
      work_space: work_space,
      work_space_polling_station: create(
        :work_space_polling_station,
        polling_station: create(
          :polling_station, name: 'Second Polling Station'
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

  it 'allows creating new observation with amended count for past observation' do
    observation = create(:turnout_observation, count: 42)

    visit work_space_turnout_observations_path(observation.work_space)
    find_data_test('amend-count-button').click
    fill_in 'What is the correct ballot count?', with: 43
    click_on 'Amend count'

    expect(page).to have_text('43')
    expect(find_data_test('past-counts-list')).to have_text('42')
  end
end
