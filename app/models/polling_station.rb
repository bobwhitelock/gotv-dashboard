class PollingStation < ApplicationRecord
  belongs_to :ward
  has_many :work_space_polling_stations

  # XXX Possibly more polling station fields should be non-nullable?
  validates_presence_of :reference

  # XXX move to decorator?
  def fully_specified_name
    "#{reference}: #{name} (#{ward.name})"
  end
end
