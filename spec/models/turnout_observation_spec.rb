
require 'rails_helper'

RSpec.describe TurnoutObservation do
  describe '#past_counts' do
    it 'returns past values for count, most recent first' do
      observation = create(:turnout_observation, count: 10)
      observation.update!(count: 30)
      # Change any other field to check ignores this and still only gets count
      # changes.
      observation.update!(created_at: DateTime.now)
      observation.update!(count: 20)
      observation.update!(count: 15)

      expect(observation.past_counts).to eq([20, 30, 10])
    end
  end
end
