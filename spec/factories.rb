
FactoryBot.define do
  factory :user do
  end

  factory :polling_station do
    ward
    name { 'Some Polling Station' }
    pre_election_registered_voters { 0 }
    pre_election_labour_promises { 0 }
  end

  factory :ward do
    council
    # XXX Nothing else required for ward yet.
  end

  factory :council do
    # XXX Nothing required for council yet.
  end

  factory :work_space do
    name { 'My Work Space' }
  end

  factory :turnout_observation do
    work_space
    polling_station
    count { 0 }
  end
end
