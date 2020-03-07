module CommitteeRoomObservation
  extend ActiveSupport::Concern

  included do
    belongs_to :committee_room
    def self.observed_for ; :committee_room ; end

    belongs_to :user

    validates_presence_of :count
  end
end
