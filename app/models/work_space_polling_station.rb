class WorkSpacePollingStation < ApplicationRecord
  belongs_to :work_space
  belongs_to :polling_station
  has_one :ward, through: :polling_station
  has_many :turnout_observations

  delegate :reference, :name, :fully_specified_name, to: :polling_station

  validates_presence_of :pre_election_labour_promises
  validates_presence_of :pre_election_registered_voters

  def as_json(options = {})
    super(options).merge(fully_specified_name: fully_specified_name)
  end
end
