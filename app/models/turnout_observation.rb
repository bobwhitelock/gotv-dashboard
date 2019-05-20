class TurnoutObservation < ApplicationRecord
  belongs_to :polling_station
  belongs_to :work_space

  def turnout_proportion
    registered_voters = polling_station.pre_election_registered_voters
    if registered_voters > 0
      self.count.to_f / registered_voters
    else
      # Return 0 when registered voters is the default, i.e. unknown, to avoid
      # dividing by 0 and returning Infinity - XXX may be better to have this
      # column be nullable (less confusing), then check and return 1 here so
      # these observations will appear last?
      0
    end
  end

  def past_counts
    self.audits
      .map { |a| a.audited_changes['count'] }
      .select { |c| c.respond_to?(:length) } # Audit involves Account change <=> `count` value will be an array.
      .map(&:first) # First entry in array is the original `count` value pre-change.
      .reverse
  end
end

