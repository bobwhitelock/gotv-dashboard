class PollingStation < ApplicationRecord
  has_and_belongs_to_many :work_spaces
  has_many :confirmed_labour_voter_observations
  has_many :turnout_observations
  belongs_to :ward

  # XXX move to decorator?
  def fully_specified_name
    "#{reference}: #{name} (#{ward.name})"
  end
end
