require 'rails_helper'
require 'shared_examples/volunteer_control_panel'

RSpec.feature 'work space dashboard', type: :feature, js: true do
  def create_committee_room
    work_space = create(:work_space)
    create(
      :committee_room,
      work_space: work_space,
      # Create with a polling station associated so shows up on dashboard.
      work_space_polling_stations: [
        create(:work_space_polling_station, work_space: work_space)
      ]
    )
  end

  it 'displays all polling stations, with key stats' do
    polling_station = create(
      :work_space_polling_station,
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

  it 'shows details/stats for latest turnout observation for each polling station' do
    polling_station = create(
      :work_space_polling_station,
      box_electors: 200,
      box_labour_promises: 100
    )
    create(
      :turnout_observation,
      work_space_polling_station: polling_station,
      count: 120,
      created_at: DateTime.new(2019, 12, 12, 11, 23)
    )

    visit work_space_path(polling_station.work_space)

    expect(page).to have_text('120 at 11:23')
    expect(page).to have_text('60.0%')
    expect(page).to have_text('60 votes / 40 votes left')
  end

  it 'shows volunteer that made latest turnout observation, if present' do
    polling_station = create(:work_space_polling_station)
    create(
      :turnout_observation,
      work_space_polling_station: polling_station,
      count: 120,
      created_at: DateTime.new(2019, 12, 12, 11, 23),
      user: create(:user, name: 'Some Campaigner')
    )

    visit work_space_path(polling_station.work_space)

    expect(page).to have_text(/120 at 11:23.*\nby Some Campaigner/)
  end

  describe 'remaining lifts tracking' do
    include_examples 'volunteer_control_panel'

    subject do
      create(:work_space_polling_station)
    end

    let :count_element do
      find_data_test("remaining-lifts-#{subject.polling_district.id}")
    end

    let(:observations_method) { :remaining_lifts_observations }
  end

  describe 'canvassers tracking' do
    include_examples 'volunteer_control_panel'

    subject { create_committee_room }

    let :count_element do
      find_data_test("canvassers-#{subject.id}")
    end

    let(:observations_method) { :canvassers_observations }
  end

  describe 'cars tracking' do
    include_examples 'volunteer_control_panel'

    subject { create_committee_room }

    let :count_element do
      find_data_test("cars-#{subject.id}")
    end

    let(:observations_method) { :cars_observations }
  end
end
