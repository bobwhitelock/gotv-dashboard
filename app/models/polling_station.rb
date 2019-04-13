class PollingStation < ApplicationRecord
  belongs_to :work_space
  has_many :confirmed_labour_voter_observations
  has_many :turnout_observations
end
