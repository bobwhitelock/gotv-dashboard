
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

    it 'orders observations by guesstimated Labour voters left' do
      many_left_ps = create(
          :polling_station,
          pre_election_registered_voters: 200,
          pre_election_labour_promises: 150,
          name: 'Many'
      )
      few_left_ps = create(
          :polling_station,
          pre_election_registered_voters: 200,
          pre_election_labour_promises: 20,
          name: 'Few'
      )
      medium_left_ps = create(
        :polling_station,
        pre_election_registered_voters: 200,
        pre_election_labour_promises: 100,
        name: 'Medium'
      )
      turnout_observations = [
        create(:turnout_observation, count: 20, polling_station: many_left_ps),
        create(:turnout_observation, count: 100, polling_station: few_left_ps),
        create(:turnout_observation, count: 100, polling_station: medium_left_ps),
      ]
      work_space = create(
        :work_space,
        polling_stations: [
          many_left_ps,
          few_left_ps,
          medium_left_ps,
        ],
        turnout_observations: turnout_observations,
      )

      data = work_space.latest_observations
      ordered_polling_station_names = data.map { |o| o.polling_station.name }

      expect(ordered_polling_station_names).to eq([
        'Many', 'Medium', 'Few'
      ])
    end

    # Not sure if this is the best way to break ties, but at least gives a
    # fairly good initial ordering.
    it 'breaks ties by ordering by Labour promises' do
      few_promises_ps = create(
        :polling_station,
        pre_election_labour_promises: 100,
        name: 'Few'
      )
      many_promises_ps = create(
        :polling_station,
        pre_election_labour_promises: 1000,
        name: 'Many'
      )
      work_space = create(
        :work_space,
        polling_stations: [
          few_promises_ps,
          many_promises_ps,
        ]
      )

      data = work_space.latest_observations
      ordered_polling_station_names = data.map { |o| o.polling_station.name }

      expect(ordered_polling_station_names).to eq([
        'Many', 'Few'
      ])
    end
  end
end
