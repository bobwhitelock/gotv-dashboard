require 'rails_helper'

RSpec.feature 'committee room creation', type: :feature, js: true do
  def polling_district_refs_for(committee_room)
    committee_room.polling_stations.flat_map do |polling_station|
      polling_station.polling_district.reference
    end.uniq
  end

  let! :work_space do
    work_space = create(:work_space)

    [
      { pd: 'ABC', ward: 'Ridgeway' },
      { pd: 'DEF', ward: 'Ridgeway' },
      { pd: 'GHI', ward: 'Central' }
    ].each do |params|
      create(
        :polling_station,
        polling_district: create(
          :polling_district,
          reference: params[:pd],
          ward: create(:ward, name: params[:ward], work_space: work_space)
        )
      )
    end

    work_space
  end

  it 'supports creation of committee room covering selected polling districts' do
    visit new_work_space_committee_room_path(work_space)
    fill_in 'Address of this committee room',
      with: 'Our House (middle of our street)'
    fill_in 'Name of lead organiser for this committee room',
      with: 'Seamus Milne'
    check 'ABC (Ridgeway)'
    check 'GHI (Central)'
    click_on 'Create committee room'

    new_committee_room = work_space.committee_rooms.first
    expect(new_committee_room.address).to eq(
      'Our House (middle of our street)'
    )
    expect(new_committee_room.organiser_name).to eq('Seamus Milne')
    expect(
      polling_district_refs_for(new_committee_room)
    ).to match_array(['ABC', 'GHI'])
  end

  it 'indicates if polling district already covered by another committee room' do
    abc_polling_station = PollingDistrict.find_by!(
       reference: 'ABC'
    ).polling_stations.first
    create(
      :committee_room,
      work_space: work_space,
      polling_stations: [abc_polling_station],
      organiser_name: 'Batman'
    )

    visit new_work_space_committee_room_path(work_space)

    expect(page).to have_text('ABC (Ridgeway) [covered by Batman]')
  end

  it 'allows selecting all polling districts to be covered by committee room' do
    visit new_work_space_committee_room_path(work_space)
    fill_in 'Address of this committee room', with: 'junk'
    fill_in 'Name of lead organiser for this committee room', with: 'junk'
    find('a', text: 'All').click
    click_on 'Create committee room'

    new_committee_room = work_space.committee_rooms.first
    expect(
      polling_district_refs_for(new_committee_room)
    ).to match_array(['ABC', 'DEF', 'GHI'])
  end
end
