
RSpec.shared_examples 'volunteer_control_panel' do
  before :each do
    visit work_space_path(subject.work_space)
  end

  let :increase_button do
    find_data_test('increase-button', root: count_element)
  end

  let :decrease_button do
    find_data_test('decrease-button', root: count_element)
  end

  it 'initializes count at 0' do
    expect(count_element).to have_text('0')
  end

  it 'allows increasing and decreasing count' do
    increase_button.click
    expect(count_element).to have_text('1')

    decrease_button.click
    expect(count_element).to have_text('0')
  end

  it 'does not allow count to go below 0' do
    decrease_button.click

    expect(count_element).to have_text('0')
  end

  it 'persists count to server once unchanged for brief period' do
    3.times { increase_button.click }
    sleep 1 # Allow JS time to make AJAX request.
    visit work_space_path(subject.work_space)

    expect(count_element).to have_text('3')
    observations = subject.send(observations_method)
    expect(observations.length).to eq 1
    expect(observations.first.count).to eq 3
  end
end
