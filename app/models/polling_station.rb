class PollingStation < ApplicationRecord
  has_and_belongs_to_many :work_spaces
  has_many :confirmed_labour_voter_observations
  has_many :turnout_observations
  belongs_to :ward

  # XXX Possibly more polling station fields should be non-nullable?
  validates_presence_of :reference

  # XXX move to decorator?
  def fully_specified_name
    "#{reference}: #{name} (#{ward.name})"
  end

  def as_json(options = {})
    super(options).merge(fully_specified_name: fully_specified_name)
  end

  def colocated_polling_stations
    # Try to merge equivalent postcodes, and reject the polling station we are looking at.
    PollingStation.all.select{ |ps| ps.id != id and ps.postcode.upcase.gsub(/\s+/, "") == postcode.upcase.gsub(/\s+/, "") }
  end

  def last_observation
    turnout_observations.max_by{ |ob| ob.created_at }
  end
end
