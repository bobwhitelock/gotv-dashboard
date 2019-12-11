class WarpCountObservation < ApplicationRecord
  # XXX Same relationships etc. here as for RemainingLiftsObservation - DRY up

  # XXX But really a WorkSpacePollingDistrict
  belongs_to :work_space_polling_station
  belongs_to :user

  # Note: Unlike other observations, WARP counts are additive rather than a
  # snapshot of the latest state for some statistic in some area. This makes
  # more sense in this case as organisers want to be able to put in the count
  # from WARP of all the new confirmed votes in an area, from the latest
  # canvassing, and then the total count will be the sum of all the (valid)
  # such counts throughout the day.
  validates_presence_of :count
end
