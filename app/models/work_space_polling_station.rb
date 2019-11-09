class WorkSpacePollingStation < ApplicationRecord
  belongs_to :work_space
  belongs_to :polling_station
  has_one :ward, through: :polling_station
  has_many :turnout_observations

  delegate :reference, :name, to: :polling_station

  validates_presence_of :pre_election_labour_promises
  validates_presence_of :pre_election_registered_voters
end
