require 'rails_helper'

RSpec.describe PollingDistrict, type: :model do
  describe '#committee_room_in_work_space' do
    it 'gives CommitteeRoom for PollingDistrict in WorkSpace' do
      polling_district = create(:polling_district)
      polling_station = create(:polling_station, polling_district: polling_district)
      work_space = create(:work_space)
      committee_room = create(:committee_room)
      ws_polling_station = create(
        :work_space_polling_station,
        polling_station: polling_station,
        work_space: work_space,
        committee_room: committee_room
      )

      expect(
        polling_district.committee_room_in_work_space(work_space)
      ).to eq(committee_room)
    end

    it 'gives nil for PollingDistrict with no committee room' do
      polling_district = create(:polling_district)
      work_space = create(:work_space)

      expect(
        polling_district.committee_room_in_work_space(work_space)
      ).to be nil
    end
  end
end
