
require 'rails_helper'

RSpec.describe PollingDistrict do
  describe '#turnout_proportion' do
    it 'gives proportion of registered voters turned out at time of observation' do
      polling_station = create(:polling_station, pre_election_registered_voters: 100)
      observation = create(:turnout_observation, count: 10, polling_station: polling_station)
      polling_district = PollingDistrict.new([
        OpenStruct.new(
          polling_station: polling_station,
          turnout_observation: observation
        )
      ])


      expect(polling_district.turnout_proportion).to eq(0.1)
    end

    it 'gives 0 when pre_election_registered_voters set to the default (0)' do
      polling_station = create(:polling_station, pre_election_registered_voters: 0)
      observation = create(:turnout_observation, count: 10, polling_station: polling_station)
      polling_district = PollingDistrict.new([
        OpenStruct.new(
          polling_station: polling_station,
          turnout_observation: observation
        )
      ])

      expect(polling_district.turnout_proportion).to eq(0)
    end

    it 'accounts for all polling_stations in calculation' do
      polling_station1 = create(:polling_station, pre_election_registered_voters: 100)
      observation1 = create(:turnout_observation, count: 10, polling_station: polling_station1)
      polling_station2 = create(:polling_station, pre_election_registered_voters: 0)
      observation2 = create(:turnout_observation, count: 20, polling_station: polling_station2)
      polling_district = PollingDistrict.new([
        OpenStruct.new(
          polling_station: polling_station1,
          turnout_observation: observation1
        ),
        OpenStruct.new(
          polling_station: polling_station2,
          turnout_observation: observation2
        )
      ])

      expect(polling_district.turnout_proportion).to eq(0.3)
    end
  end

  describe 'Labour vote guesstimation' do
    subject do
      polling_station1 = create(
        :polling_station,
        pre_election_registered_voters: 50,
        pre_election_labour_promises: 20
      )
      observation1 = create(
        :turnout_observation,
        count: 3,
        polling_station: polling_station1
      )
      polling_station2 = create(
        :polling_station,
        pre_election_registered_voters: 50,
        pre_election_labour_promises: 30
      )
      observation2 = create(
        :turnout_observation,
        count: 7,
        polling_station: polling_station2
      )

      polling_district = PollingDistrict.new([
        OpenStruct.new(
          polling_station: polling_station1,
          turnout_observation: observation1
        ),
        OpenStruct.new(
          polling_station: polling_station2,
          turnout_observation: observation2
        )
      ])
    end

    describe '#guesstimated_labour_votes' do
      it 'returns turnout * number of Labour voters' do
        expect(subject.guesstimated_labour_votes).to eq(5)
      end
    end

    describe '#guesstimated_labour_votes_left' do
      it 'returns Labour promises - guesstimated number of Labour votes' do
        expect(subject.guesstimated_labour_votes_left).to equal(45)
      end
    end
  end
end
