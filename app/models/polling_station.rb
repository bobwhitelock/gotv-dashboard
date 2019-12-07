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

  belongs_to :polling_district
  has_one :ward, through: :polling_district
  has_many :work_space_polling_stations

  # XXX Possibly more polling station fields should be non-nullable?
  validates_presence_of :reference

  # XXX move to decorator?
  def fully_specified_name
    "#{polling_district.reference} #{reference}: #{name} (#{ward.name})"
  end
end
