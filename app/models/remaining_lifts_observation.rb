class RemainingLiftsObservation < ApplicationRecord
  belongs_to :polling_district
  def self.observed_for ; :polling_district ; end
  belongs_to :user

  validates_presence_of :count
end
