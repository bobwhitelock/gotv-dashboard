# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


workspace = WorkSpace.create!(name: 'York Central 2019 Local Elections')


PollingStation.create!(name: 'York Polling station 1', pre_election_registered_voters: 0, pre_election_labour_promises: 0, work_space: workspace)
PollingStation.create!(name: 'York Polling station 2', pre_election_registered_voters: 0, pre_election_labour_promises: 0, work_space: workspace)