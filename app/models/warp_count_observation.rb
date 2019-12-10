class WarpCountObservation < ApplicationRecord
  # XXX Same relationships etc. here as for RemainingLiftsObservation - DRY up

  # XXX But really a WorkSpacePollingDistrict
  belongs_to :work_space_polling_station
  belongs_to :user

  validates_presence_of :count
end
