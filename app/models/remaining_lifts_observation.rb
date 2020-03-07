class RemainingLiftsObservation < ApplicationRecord
  # XXX But really a WorkSpacePollingDistrict
  belongs_to :work_space_polling_station
  def self.observed_for ; :work_space_polling_station ; end
  belongs_to :user

  validates_presence_of :count
end
