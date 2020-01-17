require 'rails_helper'

RSpec.feature 'work space dashboard', type: :feature, js: true do
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

  describe 'remaining lifts tracking' do
    before :each do
      @polling_station = create(:work_space_polling_station)

      visit work_space_path(@polling_station.work_space)

      @count_element = find_data_test(
        "remaining-lifts-#{@polling_station.polling_district.id}"
      )
    end

    it 'initializes count at 0' do
      expect(@count_element).to have_text('0')
    end

    it 'allows increasing and decreasing count' do
      increase_button = find_data_test('increase-button', root: @count_element)
      decrease_button = find_data_test('decrease-button', root: @count_element)

      increase_button.click
      expect(@count_element).to have_text('1')

      decrease_button.click
      expect(@count_element).to have_text('0')
    end

    it 'does not allow count to go below 0' do
      decrease_button = find_data_test('decrease-button', root: @count_element)

      decrease_button.click

      expect(@count_element).to have_text('0')
    end

    it 'persists count to server once unchanged for brief period' do
      increase_button = find_data_test('increase-button', root: @count_element)

      3.times { increase_button.click }
      sleep 1 # Allow JS time to make AJAX request.
      visit work_space_path(@polling_station.work_space)

      expect(@count_element).to have_text('3')
      remaining_lifts_observations =
        @polling_station.remaining_lifts_observations
      expect(remaining_lifts_observations.length).to eq 1
      expect(remaining_lifts_observations.first.count).to eq 3
    end
  end
end
