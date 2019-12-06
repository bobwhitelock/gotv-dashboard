require 'rails_helper'

RSpec.describe Council, type: :model do
  describe '.all' do
    it 'does not include transient Council by default' do
      normal_council = create(:council, transient: false)
      transient_council = create(:council, transient: true)

      expect(Council.all).to include(normal_council)
      expect(Council.all).not_to include(transient_council)
    end
  end
end
