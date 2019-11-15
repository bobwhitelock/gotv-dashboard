require 'rails_helper'

RSpec.describe Ward, type: :model do
  describe '#committee_room_in_work_space' do
    it 'gives CommitteeRoom for Ward in WorkSpace' do
      ward = create(:ward)
      polling_station = create(:polling_station, ward: ward)
      work_space = create(:work_space)
      committee_room = create(:committee_room)
      ws_polling_station = create(
        :work_space_polling_station,
        polling_station: polling_station,
        work_space: work_space,
        committee_room: committee_room
      )

      expect(
        ward.committee_room_in_work_space(work_space)
      ).to eq(committee_room)
    end

    it 'gives nil for ward with no committee room' do
      ward = create(:ward)
      work_space = create(:work_space)

      expect(
        ward.committee_room_in_work_space(work_space)
      ).to be nil
    end
  end
end
