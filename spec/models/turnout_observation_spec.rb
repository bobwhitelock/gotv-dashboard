
require 'rails_helper'

RSpec.describe TurnoutObservation do
  describe '#turnout_proportion' do
    it 'gives proportion of registered voters turned out at time of observation' do
      polling_station = create(:work_space_polling_station, pre_election_registered_voters: 100)
      observation = create(:turnout_observation, count: 10, work_space_polling_station: polling_station)

      expect(observation.turnout_proportion).to eq(0.1)
    end

    it 'gives 0 when pre_election_registered_voters set to the default (0)' do
      polling_station = create(:work_space_polling_station, pre_election_registered_voters: 0)
      observation = create(:turnout_observation, count: 10, work_space_polling_station: polling_station)

      expect(observation.turnout_proportion).to eq(0)
    end
  end

  describe '#guesstimated_labour_votes' do
    it 'returns turnout * number of Labour voters' do
      polling_station = create(
        :work_space_polling_station,
        pre_election_registered_voters: 100,
        pre_election_labour_promises: 50
      )
      observation = create(
        :turnout_observation,
        count: 10,
        work_space_polling_station: polling_station
      )

      expect(observation.guesstimated_labour_votes).to eq(5)
    end
  end

  describe '#guesstimated_labour_votes_left' do
    it 'returns Labour promises - guesstimated number of Labour votes' do
      polling_station = create(
        :work_space_polling_station,
        pre_election_registered_voters: 100,
        pre_election_labour_promises: 50
      )
      observation = create(
        :turnout_observation,
        count: 10,
        work_space_polling_station: polling_station
      )

      expect(observation.guesstimated_labour_votes_left).to equal(45)
    end
  end

  describe '#past_counts' do
    it 'returns past values for count, most recent first' do
      observation = create(:turnout_observation, count: 10)
      observation.update!(count: 30)
      # Change any other field to check ignores this and still only gets count
      # changes.
      observation.update!(created_at: DateTime.now)
      observation.update!(count: 20)
      observation.update!(count: 15)

      expect(observation.past_counts).to eq([20, 30, 10])
    end
  end
end
