require 'rails_helper'

RSpec.feature 'landing page', type: :feature do
  # XXX Make this test not output to STDOUT/STDERR.
  it 'allows creating demo work space using example data' do
    visit root_url
    find_data_test('demo-button').click

    expect(page.current_path).to start_with('/space/')
    new_work_space_identifier = page.current_path.split('/').third
    new_work_space = WorkSpace.find_by!(identifier: new_work_space_identifier)
    expect(new_work_space.name).to match(/Vauxhall Election [0-9]{4} \[Demo\]/)
    # Should use example data from `example_data` directory, this is just a
    # minimal smoke test that this is working (main behaviour of importing
    # covered by ContactCreatorImporter tests).
    expect(new_work_space.polling_stations.length).to eq(51)
  end
end
