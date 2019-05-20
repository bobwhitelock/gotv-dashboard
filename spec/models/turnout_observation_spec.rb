
require 'rails_helper'

RSpec.describe TurnoutObservation do
  describe '#turnout_proportion' do
    it 'gives proportion of registered voters turned out at time of observation' do
      polling_station = create(:polling_station, pre_election_registered_voters: 100)
      observation = create(:turnout_observation, count: 10, polling_station: polling_station)

      expect(observation.turnout_proportion).to eq(0.1)
    end

    it 'gives 0 when pre_election_registered_voters set to the default (0)' do
      polling_station = create(:polling_station, pre_election_registered_voters: 0)
      observation = create(:turnout_observation, count: 10, polling_station: polling_station)

      expect(observation.turnout_proportion).to eq(0)
    end
  end
end
