class PollingStation < ApplicationRecord
  has_many :confirmed_labour_voter_observations
  has_many :turnout_observations
  belongs_to :ward
  belongs_to :council
end
