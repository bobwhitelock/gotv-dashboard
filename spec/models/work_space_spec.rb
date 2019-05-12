
require 'rails_helper'

RSpec.describe WorkSpace do
  describe '#latest_observations' do
    subject do
      create(
        :work_space,
        polling_stations: [polling_station],
      )
    end
    let (:polling_station) { create(:polling_station) }

    it 'gives most recent turnout observation for each polling station' do
      another_observation = create(
        :turnout_observation,
        polling_station: polling_station,
        count: 11,
        created_at: 2.hours.ago)
      most_recent_observation = create(
        :turnout_observation,
        polling_station: polling_station,
        count: 22,
        created_at: 1.hour.ago
      )
      subject.turnout_observations = [
        most_recent_observation,
        another_observation,
      ]
      subject.save!

      data = subject.latest_observations

      first_entry = data.first
      expect(first_entry.polling_station).to eq(polling_station)
      expect(first_entry.turnout_observation).to eq(most_recent_observation)
    end

    it 'gives placeholder empty observation for polling station without observation' do
      data = subject.latest_observations

      first_entry = data.first
      expect(first_entry.polling_station).to eq(polling_station)
      expect(first_entry.turnout_observation.count).to eq(0)
      expect(first_entry.turnout_observation.created_at).to be_nil
    end

    # XXX Not sure if this is the best ordering.
    it 'orders observations from lowest to highest turnout' do
      high_expected_turnout_ps =
        create(:polling_station, pre_election_registered_voters: 200, name: 'High')
      low_expected_turnout_ps =
        create(:polling_station, pre_election_registered_voters: 100, name: 'Low')
      medium_expected_turnout_ps =
        create(:polling_station, pre_election_registered_voters: 100, name: 'Medium')
      turnout_observations = [
        create(:turnout_observation, count: 150, polling_station: high_expected_turnout_ps),
        create(:turnout_observation, count: 20, polling_station: low_expected_turnout_ps),
        create(:turnout_observation, count: 50, polling_station: medium_expected_turnout_ps),
      ]
      work_space = create(
        :work_space,
        polling_stations: [
          high_expected_turnout_ps,
          low_expected_turnout_ps,
          medium_expected_turnout_ps,
        ],
        turnout_observations: turnout_observations,
      )

      data = work_space.latest_observations
      ordered_polling_station_names = data.map { |o| o.polling_station.name }

      expect(ordered_polling_station_names).to eq([
        'Low', 'Medium', 'High'
      ])
    end
  end
end
