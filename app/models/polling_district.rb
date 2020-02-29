class PollingDistrict < ApplicationRecord
  belongs_to :ward
  has_many :polling_stations
  has_many :warp_count_observations
  has_many :remaining_lifts_observations

  validates_presence_of :reference

  def committee_room
    # XXX Better way to do this? Moving CommitteeRoom reference to district
    # level might help?
    polling_stations.first&.committee_room
  end

  def work_space
    # XXX As above - better way to do this?
    polling_stations.first&.work_space
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

  def last_remaining_lifts_observation
    last_observation_for(remaining_lifts_observations)
  end
end
