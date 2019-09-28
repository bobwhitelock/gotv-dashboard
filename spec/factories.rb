
FactoryBot.define do
  factory :user do
  end

  factory :polling_station do
    ward
    name { 'Some Polling Station' }
    reference { 'SPS-1' }
    pre_election_registered_voters { 0 }
    pre_election_labour_promises { 0 }
  end

  factory :ward do
    council
    name { 'Some Ward' }
    code { 'E1234' }
  end

  factory :council do
    name { 'Some Council' }
    code { 'S1234' }
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
