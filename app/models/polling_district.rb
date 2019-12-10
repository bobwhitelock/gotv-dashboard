class PollingDistrict < ApplicationRecord
  belongs_to :ward
  has_many :polling_stations

  validates_presence_of :reference

  def committee_room_in_work_space(work_space)
    # XXX Assumption: if one PollingStation is handled by CommitteeRoom then
    # the whole PollingDistrict is. If this ever changes then this method and
    # anywhere using it won't work correctly
    # XXX This assumption no longer holds, but should be OK in the one place we
    # use this (which might be removed soon in any case).
    polling_station = polling_stations.first
    WorkSpacePollingStation.find_by(
      work_space: work_space, polling_station: polling_station
    )&.committee_room
  end

  # XXX move to decorator?
  # Similar to `PollingStation#fully_specified_name`
  def fully_specified_name
    "#{reference}: #{addresses} (#{ward.name})"
  end

  # XXX Move to decorator?
  def name
    "#{reference} (#{ward.name})"
  end

  # XXX Move to decorator?
  def addresses
    polling_stations.map(&:name).uniq.join('; ')
  end
end
