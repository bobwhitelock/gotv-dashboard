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

  belongs_to :committee_room, required: false
  belongs_to :polling_district
  has_one :ward, through: :polling_district
  has_one :work_space, through: :ward
  has_many :turnout_observations

  # XXX Possibly more polling station fields should be non-nullable?
  validates_presence_of :reference

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

  def last_turnout_observation
    last_observation_for(turnout_observations)
  end
end
