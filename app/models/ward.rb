class Ward < ApplicationRecord
  has_many :polling_districts
  has_many :polling_stations, through: :polling_districts
  belongs_to :council

  validates_presence_of :name
  validates_presence_of :code

  def committee_room_in_work_space(work_space)
    # XXX Assumption: if one PollingStation is handled by CommitteeRoom then
    # the whole Ward is. If this ever changes then this method and anywhere
    # using it won't work correctly
    polling_station = polling_stations.first
    WorkSpacePollingStation.find_by(
      work_space: work_space, polling_station: polling_station
    )&.committee_room
  end
end
