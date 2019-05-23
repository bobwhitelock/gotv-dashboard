PollingDistrict = Struct.new(:observation_pairs) do
  def turnout_proportion
    registered_voters = pre_election_registered_voters

    if registered_voters.positive?
      total_count = observations.map { |o| o.count.to_f }.sum
      total_count / registered_voters
    else
      # Return 0 when registered voters is the default, i.e. unknown, to avoid
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
    (turnout_proportion * pre_election_labour_promises).to_i
  end

  # Same caveats as above, this is just the inverse to get a guesstimate of how
  # many Labour promises haven't voted yet.
  def guesstimated_labour_votes_left
    pre_election_labour_promises - guesstimated_labour_votes
  end

  def pre_election_labour_promises
    polling_stations.map(&:pre_election_labour_promises).sum
  end

  def pre_election_registered_voters
    polling_stations.map(&:pre_election_registered_voters).sum
  end

  def observations
    observation_pairs.map(&:turnout_observation)
  end

  def polling_stations
    observation_pairs.map(&:polling_station)
  end
end
