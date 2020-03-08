class PollingDistrict < ApplicationRecord
  belongs_to :ward
  has_many :polling_stations, -> { distinct.order(:reference) }
  has_many :warp_count_observations
  has_many :remaining_lifts_observations

  validates_presence_of :reference

  def committee_room
    # XXX Better way to do this? Moving CommitteeRoom reference to district
    # level might help?
    polling_stations.first&.committee_room
  end

  def work_space
    # XXX As above - better way to do this?
    polling_stations.first&.work_space
  end

  def work_space_id
    # XXX As above
    work_space.id
  end

  # XXX move to decorator?
  # Similar to `PollingStation#fully_specified_name`
  def fully_specified_name
    "#{reference}: #{addresses} (#{ward.name})"
  end

  # XXX Move to decorator?
  def name
    "#{reference} (#{ward.name})"
  end

  # XXX Move to decorator?
  def addresses
    polling_stations.map(&:name).uniq.join('; ')
  end

  def last_remaining_lifts_observation
    last_observation_for(remaining_lifts_observations)
  end

  def turnout_proportion
    total_district_count = \
      polling_stations.map do |polling_station|
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

  def confirmed_labour_votes_from_warp
    warp_count_observations.where(is_valid: true).sum('count')
  end

  def remaining_labour_votes_from_warp
    box_labour_promises - confirmed_labour_votes_from_warp
  end
end
