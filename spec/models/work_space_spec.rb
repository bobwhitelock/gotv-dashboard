
require 'rails_helper'

RSpec.describe WorkSpace do
  describe '#latest_observations' do
    subject do
      create(
        :work_space,
        work_space_polling_stations: [polling_station],
      )
    end
    let (:polling_station) { create(:work_space_polling_station) }

    it 'gives most recent turnout observation for each polling station' do
      another_observation = create(
        :turnout_observation,
        work_space_polling_station: polling_station,
        count: 11,
        created_at: 2.hours.ago)
      most_recent_observation = create(
        :turnout_observation,
        work_space_polling_station: polling_station,
        count: 22,
        created_at: 1.hour.ago
      )

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
  end
end
