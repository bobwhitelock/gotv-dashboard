
SimpleCov.start 'rails' do
  # Track branch as well as line coverage.
  enable_coverage :branch

  # Track and group coverage of all Rake tasks.
  add_group 'Rake tasks', 'lib/tasks'
  track_files 'lib/tasks/**/*.rake'

  # Group coverage for ActiveAdmin configs.
  add_group 'Admin configs', 'app/admin'
end
