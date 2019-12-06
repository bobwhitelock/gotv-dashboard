require 'rails_helper'

RSpec.describe WorkSpacePollingStation, type: :model do
  describe '#polling_district_stations' do
    it 'gives all work space polling stations in same district' do
      polling_district = 'BA1'
      work_space = create(:work_space)
      # Reverse creation order to ensure sorted alphabetically by reference.
      district_polling_station_2 = create(
        :work_space_polling_station,
        work_space: work_space,
        polling_station: create(
          :polling_station,
          reference: 'BA1-2',
          polling_district: polling_district
        )
      )
      district_polling_station_1 = create(
        :work_space_polling_station,
        work_space: work_space,
        polling_station: create(
          :polling_station,
          reference: 'BA1-1',
          polling_district: polling_district
        )
      )
      _some_other_polling_station = create(
        :work_space_polling_station,
        work_space: work_space
      )


      polling_district_stations = \
        district_polling_station_1.polling_district_stations

      expect(polling_district_stations.length).to eq(2)
      expect(polling_district_stations.first).to eq(district_polling_station_1)
      expect(polling_district_stations.second).to eq(district_polling_station_2)
    end
  end
end
