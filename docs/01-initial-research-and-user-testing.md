
Meeting on 2019-05-13 with:
- 3 Labour campaigners from London (Matt, Matthew, Josie) and 1 from Luton
  (forgot his name)
- James Moulding and Hannah O'Rourke (CL organisers)
- Harry Fox, Duncan Walker, and Bob Whitelock (CL developers/volunteers)

# Discussion

- Useful to know where people are turning out, where to send volunteers

- Matthew doesn't think that useful to record voters on door at polling station
  (telling)
  - Matthew thinks people who can't go knocking doors would be more useful to
    make tea, phone banking etc.

- There is some thought that phone banking is illegal now with GDPR - this is
  not true though (probably?)

- Normally go round polling stations 3 or 4 times on polling day

- If not many people needed in area could close committee room and/or
  redistribute volunteers

- Most people vote 4-8PM; similar also for volunteer turnout
  - Also in morning
  - Somewhat depends on area, demographics e.g. night shift workers

- Might have ~8 committee rooms in London marginal, less elsewhere
  - Varies by area
  - Also varies based on whether people have cars (less rooms needed), how many
    volunteers (more rooms needed), how rural (more rooms needed)

- Labour party strategy is London-focused, assumes many volunteers able to
  knock many places throughout day

- Turnout app
  - Already exists to report turnout
  - Flaw: aimed at telling, but people who are inclined to do telling (older)
    are not likely to use app
  - Flaw: not live, have to run a report and then print that out to make use of
    the data
  - The ideal use case for the app is:
    - Have people telling on polling stations
    - Enter individual voters who tell them how they voted in turnout app
    - Data then reported back to committee room
    - Road groups can then be distributed with voters crossed off
  - App appeals to Labour staffers, who often work in by-elections when there
    are many volunteers (where this fine-grained data works well/enough people
    are available for this to be usable)
  - Normally Saturday before election organiser will update Contact Creator
    with latest Labour promises, can then export this to Turnout

- Would be useful to see where volunteer groups are, GPS reporting of locations
  - So can send new volunteers to join existing group, make them easy to find +
    not risk them already be coming back
  - So organiser can track where they are

- Round = group of roads, 1-2 hours, 100-200 doors
  - Road group generally correlates with a polling district, but not always
  - Organiser creates road groups (via clunky interface) in Contact Creator
    - When creating, a road group Must be within a ward, it may cross polling
      districts

- Can appoint polling agents to collect polling figures on number of votes cast
  from polling stations (get figure per box in polling place)
  - Or, depending on area:
    - Polling places might just let anyone ask for these
    - Figures may be posted on the door of the polling place
  - Can appoint limited number of these, several weeks in advance
    - Idea is to not encourage non-voters to come into polling place, and maybe
      intimidate people
  - Polling places will also report the number of votes cast at the end of the
    day for each box
    - Can use to verify data obtained on the day
    - Also useful for future reference (or now to get historical data), to see
      turnout per polling place/box
  - Also later appoint counting agents to check count - 2 per box

- Polling districts = contain 1+ polling station
  - Unusual to have more than one physical polling building per polling
    district, but possible
  - Polling station == box where votes are put
    - Boxes within region given arbitrary names - might be 'A1', 'A2' etc., or
      '1', '2', '3' etc., or something else
  - It is possible for multiple wards to vote within the same polling place

- Matthew (and many other organisers) has tried to make structured use of
  available data on the day with own docs/spreadsheets (see Slack for examples)
  - But this tends to break down as too much effort/not worth it on the day,
    falls back to just phone + paper

- Key data points effecting GOTV decision making on the day:
  - Turnout by ward
  - Where volunteers are, how well distributed
  - Labour promises made vs voted

- Labour promises
  - Currently count up how many people out of Labour promises throughout day
    that have voted
  - All tracked with paper
  - This made difference at last council by-election Matt run, tracking Labour
    promises then knocking on doors of Labour promises who have not yet voted
    to get them to vote

- Would be useful to record current volunteers in an area
  - But this is hard to track
  - Labour party currently uses sign in system per committee room (up to
    organiser what this is, could be pen and paper or app etc.)
    - But no sign out system, people may just leave at the end of a round etc.
  - Committee organisers also lie/mislead as they forget how many people they
    have out

- Matthew: it is really only useful to know data that would effect actions you
  take on the day

- Organisers are often risk-adverse to using new stuff, don't want to risk
  using wrong data on the day/things breaking down - trying something new is a
  risk so need high level of trust to use

- Tories have slightly more complex system - went down on election day 2017
  - Requires connectivity; Labour systems just require data to be downloaded
    locally ahead of time

- Lots of volunteers on polling day are retired, resistant to using new tech

- Duncan thinks the current app is focused on a single committee room, would
  not currently scale well to having multiple committee rooms using same work
  space

- Matt wants to be able to confirm data, check things before they're treated as
  real - doesn't want junk data (due to malicious use/mistakes) to go in
  automatically and then he makes decisions based off this

- People may report things to organiser, or put wrong data in to a new system,
  non-maliciously:
  - Mistakes
  - Assumptions - e.g. assume someone voted Labour based on insufficient info
    like because they smiled; assume everyone will vote/did vote Labour because
    one person said they did
  - They also may actually report things semi-maliciously in an attempt to
    appear like they have been campaigning more successfully than they actually
    have to candidate/organisers etc.

- Gathering/displaying turnout by road group is most useful, but by polling
  district is OK

- Some assumptions
  - Can't assume everyone has a smartphone, often older people
    - But if people have a smartphone they probably already use Whatsapp, can be
      used to share links
  - Committee rooms will be known in advance
  - Security/privacy - not requiring login but using (just about) impossible to
    guess URL is OK
    - No sensitive data stored for now anyway

# Possible tasks to do for App test

Plan to test app in field in small area of Ilford, on EU election on 2019-05-23

- Would be useful to order with low turnout areas with high numbers of Labour
  promises at top
- Possibly useful to see past turnout on dashboard to see how close observed
  turnout is, how high this may get
- Eventually would be useful for system to be clever and tell you where to go -
  for now it should just present all relevant info to organiser and they can
  decide what to do
- Key features to test
  - Make corrections to previous numbers
  - Labour promises
  - Display ward in some way beside each polling station
  - Have name + phone number input as extra step after any individual
    observation
    - from then on this will be tied to the session and displayed alongside
      observations
    - show user id + name + phone number alongside each observation
- Show volunteers
- Get in polling stations for more areas - in particular Ilford
- People could use app as sign in method for committee room (give name +
  phone), and then we can show this name alongside their entries
