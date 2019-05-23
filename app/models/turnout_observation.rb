class TurnoutObservation < ApplicationRecord
  belongs_to :polling_station
  belongs_to :work_space
  # XXX Make this required?
  belongs_to :user, required: false

  delegate :pre_election_registered_voters,
    :pre_election_labour_promises,
    to: :polling_station

  # NOTE: Make sure all methods here also have trivial versions for null object
  # (UnobservedTurnoutObservation), if they will be called from main dashboard
  # page (`app/views/work_spaces/show.html.erb`).
  # XXX Not sure how applicable this still is.

  def past_counts
    self.audits
      .map { |a| a.audited_changes['count'] }
      .select { |c| c.respond_to?(:length) } # Audit involves `count` change <=> `count` value will be an array.
      .map(&:first) # First entry in array is the original `count` value pre-change.
      .reverse
  end
end

