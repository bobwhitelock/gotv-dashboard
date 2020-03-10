class TurnoutObservation < ApplicationRecord
  belongs_to :polling_station
  def self.observed_for ; :polling_station ; end
  # XXX Make this required?
  belongs_to :user, required: false
  has_one :work_space, through: :polling_station

  def past_counts
    self.audits
      .map { |a| a.audited_changes['count'] }
      .select { |c| c.respond_to?(:length) } # Audit involves `count` change <=> `count` value will be an array.
      .map(&:first) # First entry in array is the original `count` value pre-change.
      .reverse
  end
end

