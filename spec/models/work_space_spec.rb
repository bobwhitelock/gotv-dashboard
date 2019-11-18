
require 'rails_helper'

RSpec.describe WorkSpace do
  describe '#latest_observations_by_committee_room' do
    subject do
      create(
        :work_space,
        work_space_polling_stations: [polling_station]
      )
    end

    let :polling_station do
      create(
        :work_space_polling_station,
        committee_room: create(:committee_room)
      )
    end

    it 'gives most recent turnout observation for each polling station' do
      _another_observation = create(
        :turnout_observation,
        work_space_polling_station: polling_station,
        count: 11,
        created_at: 2.hours.ago
      )
      most_recent_observation = create(
        :turnout_observation,
        work_space_polling_station: polling_station,
        count: 22,
        created_at: 1.hour.ago
      )

      data = subject.latest_observations_by_committee_room

      _, first_group = data.first
      first_entry = first_group.first
      expect(first_entry.polling_station).to eq(polling_station)
      expect(first_entry.turnout_observation).to eq(most_recent_observation)
    end

    it 'gives placeholder empty observation for polling station without observation' do
      data = subject.latest_observations_by_committee_room

      _, first_group = data.first
      first_entry = first_group.first
      expect(first_entry.polling_station).to eq(polling_station)
      expect(first_entry.turnout_observation.count).to eq(0)
      expect(first_entry.turnout_observation.created_at).to be_nil
    end

    it 'groups polling stations/observations by committee room' do
      data = subject.latest_observations_by_committee_room

      committee_room, = data.first
      expect(committee_room).to eq(polling_station.committee_room)
    end
  end

  describe '#wards' do
    it "returns all wards for given workspace's polling stations" do
      ward_1 = create(:ward, name: 'Ward 1')
      ward_1_polling_station = create(:polling_station, ward: ward_1)
      ward_2 = create(:ward, name: 'Ward 2')
      ward_2_polling_stations = create_list(:polling_station, 2, ward: ward_2)
      all_polling_stations = [ward_1_polling_station, *ward_2_polling_stations]
      work_space = create(
        :work_space,
        work_space_polling_stations: all_polling_stations.map do |ps|
        create(:work_space_polling_station, polling_station: ps)
      end)

      wards = work_space.wards
      ward_names = wards.map(&:name)

      # Note each ward with any number of polling stations appears only once.
      expect(ward_names).to eq(['Ward 1', 'Ward 2'])
    end
  end
end
