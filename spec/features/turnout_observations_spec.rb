require 'rails_helper'

RSpec.feature 'turnout observation logging', type: :feature, js: true do
  let!(:work_space) do
    create(:work_space)
  end

  def create_polling_station(**kwargs)
    create(
      :work_space_polling_station,
      work_space: work_space,
      polling_station: create(:polling_station, **kwargs)
    )
  end

  def search_for_polling_station_matching(search_term)
    visit start_work_space_turnout_observations_path(work_space)
    fill_in placeholder: 'Start typing...', with: search_term
    send_keys :down, :enter
  end

  def enter_ballot_count_of(ballot_count)
    fill_in placeholder: 'Enter ballot count...', with: ballot_count
    send_keys :enter
  end

  it 'allows logging turnout observation for work space' do
    create_polling_station(name: 'polling station 42')

    search_for_polling_station_matching '42'
    enter_ballot_count_of '101'

    sleep 0.1
    expect(body_text).to match(
      /Your committee room received the count of 101 .* polling station 42/
    )
  end

  it 'gives list of ballot boxes at same location, with link to log these' do
    wsps = create_polling_station(
      name: 'polling station 42',
      postcode: 'SPS 1AA'
    )
    create_polling_station(
      name: 'polling station 43',
      postcode: wsps.postcode
    )

    search_for_polling_station_matching '42'
    enter_ballot_count_of '101'

    sleep 0.1
    expect(body_text).to include(
      'We think these ballot boxes are in the same building'
    )
    click_on 'Click here to enter a new count'
    expect(body_text).to match(
      /Recording ballot count for .* polling station 43/
    )
  end

  it 'gives link to re-select polling station after selecting' do
    create_polling_station(name: 'polling station 42')

    search_for_polling_station_matching '42'
    click_on 'Click here to select again'

    expect(body_text).to include('Which polling station are you at?')
  end

  it 'gives link to re-log observation after logging' do
    create_polling_station(name: 'polling station 42')

    search_for_polling_station_matching '42'
    enter_ballot_count_of '101'
    click_on 'Click here to enter a corrected count'

    expect(body_text).to match(
      /Recording ballot count for .* polling station 42/
    )
  end
end
