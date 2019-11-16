module CommitteeRoomObservation
  extend ActiveSupport::Concern

  included do
    belongs_to :committee_room
    belongs_to :user

    validates_presence_of :count
  end
end
