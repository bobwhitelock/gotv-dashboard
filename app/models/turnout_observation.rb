class TurnoutObservation < ApplicationRecord
  belongs_to :polling_station
  def self.observed_for ; :polling_station ; end
  # XXX Make this required?
  belongs_to :user, required: false
  has_one :work_space, through: :polling_station

  delegate :box_electors, :box_labour_promises, to: :polling_station

  # NOTE: Make sure all methods here also have trivial versions for null object
  # (UnobservedTurnoutObservation), if they will be called from main dashboard
  # page (`app/views/work_spaces/show.html.erb`).

  # XXX This also uses hacks and is a proxy for a non-existent
  # WorkSpacePollingDistrict method (see
  # https://github.com/bobwhitelock/gotv-dashboard/issues/100).
  def turnout_proportion
    total_district_count = \
      polling_station.work_space_polling_district_stations.map do |polling_station|
      (polling_station.last_observation&.count || 0)
    end.sum

    if box_electors > 0
      total_district_count.to_f / box_electors
    else
      # Return 0 when `box_electors` is the default, i.e. unknown, to avoid
      # dividing by 0 and returning Infinity - XXX may be better to have this
      # column be nullable (less confusing), then check and return 1 here so
      # these observations will appear last?
      0
    end
  end

  # I'm not sure if this is at all accurate enough to be useful (and not
  # misleading and counterproductive), but best I can think of at the moment:
  # guesstimate Labour votes so far as the observed turnout * number of
  # pre-election Labour promises.
  #
  # Assumes Labour voters vote at same rate as average voter, that pre-election
  # figures are roughly accurate, that Labour promises are roughly equal to
  # number who will actually vote Labour (else this is likely to be very
  # inaccurate, though I guess it should be inaccurate by same proportion for
  # every polling station) etc.
  def guesstimated_labour_votes
    (turnout_proportion * box_labour_promises).to_i
  end

  # Same caveats as above, this is just the inverse to get a guesstimate of how
  # many Labour promises haven't voted yet.
  def guesstimated_labour_votes_left
    box_labour_promises - guesstimated_labour_votes
  end

  def past_counts
    self.audits
      .map { |a| a.audited_changes['count'] }
      .select { |c| c.respond_to?(:length) } # Audit involves `count` change <=> `count` value will be an array.
      .map(&:first) # First entry in array is the original `count` value pre-change.
      .reverse
  end
end

