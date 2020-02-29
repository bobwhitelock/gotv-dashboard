
FactoryBot.define do
  factory :user do
  end

  factory :polling_station do
    work_space
    polling_district
    name { 'Some Polling Station' }
    reference { 'SPS-1' }
    box_electors { 0 }
    box_labour_promises { 0 }
    postal_electors { 0 }
    postal_labour_promises { 0 }
  end

  factory :polling_district do
    ward
    reference { 'PD' }
  end

  factory :ward do
    name { 'Some Ward' }
  end

  factory :work_space do
    name { 'My Work Space' }
  end

  factory :committee_room do
    work_space
    address { '5 Organiser Street, GE1 5LA' }
    organiser_name { 'Some Organiser' }
  end

  factory :turnout_observation do
    polling_station
    count { 0 }
  end

  factory :warp_count_observation do
    user
    polling_district
    count { 0 }
  end

  factory :remaining_lifts_observation do
    user
    polling_district
    count { 0 }
  end

  factory :canvassers_observation do
    user
    committee_room
    count { 0 }
  end

  factory :cars_observation do
    user
    committee_room
    count { 0 }
  end
end
