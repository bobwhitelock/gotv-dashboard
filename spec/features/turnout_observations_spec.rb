require 'rails_helper'

RSpec.feature 'turnout observation logging', type: :feature, js: true do
  it 'allows logging turnout observation for work space' do
    wsps = create(
      :work_space_polling_station,
      polling_station: create(:polling_station, name: 'polling station 42')
    )
    work_space = wsps.work_space

    visit start_work_space_turnout_observations_path(work_space)
    fill_in placeholder: 'Start typing...', with: '42'
    find('body').send_keys :down, :enter
    fill_in placeholder: 'Enter ballot count...', with: '101'
    find('body').send_keys :enter

    sleep 0.1
    expect(find('body').text).to match(
      /Your committee room received the count of 101 .* polling station 42/
    )
  end

  it 'gives list of ballot boxes at same location, with link to log these' do
    wsps = create(
      :work_space_polling_station,
      polling_station: create(
        :polling_station,
        name: 'polling station 42',
        postcode: 'SPS 1AA'
      )
    )
    work_space = wsps.work_space
    create(
      :work_space_polling_station,
      work_space: work_space,
      polling_station: create(
        :polling_station,
        name: 'polling station 43',
        postcode: wsps.postcode
      )
    )

    visit start_work_space_turnout_observations_path(work_space)
    fill_in placeholder: 'Start typing...', with: '42'
    find('body').send_keys :down, :enter
    fill_in placeholder: 'Enter ballot count...', with: '101'
    find('body').send_keys :enter

    sleep 0.1
    expect(find('body').text).to include(
      'We think these ballot boxes are in the same building'
    )
    click_on 'Click here to enter a new count'
    expect(find('body').text).to match(
      /Recording ballot count for .* polling station 43/
    )
  end

  it 'gives link to re-select polling station after selecting' do
    wsps = create(
      :work_space_polling_station,
      polling_station: create(:polling_station, name: 'polling station 42')
    )
    work_space = wsps.work_space

    visit start_work_space_turnout_observations_path(work_space)
    fill_in placeholder: 'Start typing...', with: '42'
    find('body').send_keys :down, :enter
    click_on 'Click here to select again'

    expect(find('body').text).to include('Which polling station are you at?')
  end

  it 'gives link to re-log observation after logging' do
    wsps = create(
      :work_space_polling_station,
      polling_station: create(:polling_station, name: 'polling station 42')
    )
    work_space = wsps.work_space

    visit start_work_space_turnout_observations_path(work_space)
    fill_in placeholder: 'Start typing...', with: '42'
    find('body').send_keys :down, :enter
    fill_in placeholder: 'Enter ballot count...', with: '101'
    find('body').send_keys :enter
    click_on 'Click here to enter a corrected count'

    expect(find('body').text).to match(
      /Recording ballot count for .* polling station 42/
    )
  end
end
