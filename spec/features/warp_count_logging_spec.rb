require 'rails_helper'

RSpec.feature 'warp count logging', type: :feature do
  def log_warp_count(for_polling_district:, with_count:, with_notes: '')
    visit work_space_polling_district_warp_count_observations_path(
      for_polling_district.work_space,
      for_polling_district
    )
    find_data_test('new-warp-count-input').fill_in(with: with_count)
    find_data_test(
      'new-warp-count-notes-input'
    ).fill_in(with: with_notes)
    click_on 'Record WARP count'
  end

  it 'allows logging WARP count for polling district' do
    polling_district = create(:polling_district)

    log_warp_count(
      for_polling_district: polling_district,
      with_count: 50,
      with_notes: 'Abbey Road road group'
    )

    expect(page).to have_text(50)
    expect(page).to have_text('Abbey Road road group')
    warp_count_observations = polling_district.warp_count_observations
    expect(warp_count_observations.length).to eq(1)
    new_observation = warp_count_observations.first
    expect(new_observation.count).to eq(50)
    expect(new_observation.notes).to eq('Abbey Road road group')
    expect(new_observation.is_valid).to be true
  end

  it 'allows invalidating logged WARP counts' do
    polling_district = create(:polling_district)

    log_warp_count(for_polling_district: polling_district, with_count: 3)
    click_on 'Invalidate WARP count'

    new_observation = polling_district.warp_count_observations.first
    expect(new_observation.is_valid).to be false
  end
end
