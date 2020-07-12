
SimpleCov.start 'rails' do
  # Track branch as well as line coverage.
  enable_coverage :branch

  track_files  '{app/**/*.rb,lib/**/*.rake}'
  add_group 'Admin configs', 'app/admin'
  add_group 'Decorators', 'app/decorators'
  add_group 'Libraries', 'app/lib'
  add_group 'Rake tasks', 'lib/tasks'
end
