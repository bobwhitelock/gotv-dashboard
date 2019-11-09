class PollingStation < ApplicationRecord
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
end
