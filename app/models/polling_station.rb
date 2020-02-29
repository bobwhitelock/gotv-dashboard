class PollingStation < ApplicationRecord
  # XXX Columns `ward_id` and `polling_district` can be dropped from this table
  # once sure this won't cause issues (post-election).
  #
  # XXX Possibly `name` (which is really address) should move to
  # PollingDistrict, though don't know 100% that this is always the same for
  # each PollingStation for PollingDistrict.
  #
  # XXX Possibly this model and all usage should be renamed to BallotBox,
  # PollingStation is too overloaded a term and people have different
  # interpretations - can be considered to mean 'polling place' (most common)
  # or 'ballot box' (our usage, and technically correct).

  belongs_to :work_space
  belongs_to :committee_room, required: false
  belongs_to :polling_district
  has_one :ward, through: :polling_district
  has_many :turnout_observations

  # XXX Possibly more polling station fields should be non-nullable?
  validates_presence_of :reference
  validates_presence_of :box_labour_promises
  validates_presence_of :box_electors
  validates_presence_of :postal_labour_promises
  validates_presence_of :postal_electors

  # XXX move to decorator?
  def fully_specified_name
    "#{polling_district.reference} #{reference}: #{name} (#{ward.name})"
  end

  def as_json(options = {})
    super(options).merge(fully_specified_name: fully_specified_name)
  end

  def colocated_polling_stations
    # Try to merge equivalent postcodes, and reject the polling station we are
    # looking at.
    work_space.polling_stations.select do |ps|
      ps.id != id && ps.postcode.upcase.gsub(/\s+/, "") == postcode.upcase.gsub(/\s+/, "")
    end
  end

  # XXX Refactor this to same style as other obsevations - use
  # `last_observation_for` etc?
  def last_observation
    turnout_observations.max_by(&:created_at)
  end

  def last_remaining_lifts_observation
    last_observation_for(polling_district.remaining_lifts_observations)
  end

  # XXX Existence of these 2 methods and all usage is a total hack - we use
  # first PollingStation for PollingDistrict as a proxy for a
  # 'WorkSpacePollingDistrict', to work around this not existing and being
  # involved to add. Should fix at some point post-election -
  # https://github.com/bobwhitelock/gotv-dashboard/issues/120.
  def work_space_polling_district_proxy?
    work_space_polling_district_stations.first == self
  end

  def work_space_polling_district_stations
    PollingStation.where(
      polling_district: polling_district,
      work_space: work_space
    ).order(:reference)
  end

  def confirmed_labour_votes_from_warp
    polling_district.warp_count_observations.where(is_valid: true).sum('count')
  end

  def remaining_labour_votes_from_warp
    box_labour_promises - confirmed_labour_votes_from_warp
  end
end
