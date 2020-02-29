require 'rails_helper'

RSpec.describe PollingDistrict, type: :model do
  describe '#turnout_proportion' do
    it 'gives latest known proportion of box electors turned out' do
      polling_station = create(:polling_station, box_electors: 100)
      polling_district = polling_station.polling_district
      create(:turnout_observation, count: 10, polling_station: polling_station)

      expect(polling_district.turnout_proportion).to eq(0.1)
    end

    it 'gives 0 when box_electors set to the default (0)' do
      polling_station = create(:polling_station, box_electors: 0)
      polling_district = polling_station.polling_district
      create(:turnout_observation, count: 10, polling_station: polling_station)

      expect(polling_district.turnout_proportion).to eq(0)
    end

    # XXX Add test that works correctly with multiple figures set.
  end

  describe '#guesstimated_labour_votes' do
    it 'returns turnout * number of Labour voters' do
      polling_station = create(
        :polling_station,
        box_electors: 100,
        box_labour_promises: 50
      )
      polling_district = polling_station.polling_district
      create(
        :turnout_observation,
        count: 10,
        polling_station: polling_station
      )

      expect(polling_district.guesstimated_labour_votes).to eq(5)
    end
  end

  describe '#guesstimated_labour_votes_left' do
    it 'returns Labour promises - guesstimated number of Labour votes' do
      polling_station = create(
        :polling_station,
        box_electors: 100,
        box_labour_promises: 50
      )
      polling_district = polling_station.polling_district
      create(
        :turnout_observation,
        count: 10,
        polling_station: polling_station
      )

      expect(polling_district.guesstimated_labour_votes_left).to equal(45)
    end
  end
end
