require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#info' do
    it 'gives ID and indicates user is unknown, when no name' do
      user = create(:user, phone_number: '555')

      expect(user.info).to eq("Volunteer #{user.id} (name unknown)")
    end

    it 'gives name and phone, when name and phone set' do
      user = create(:user, name: 'Chewbacca', phone_number: '555')

      expect(user.info).to eq("Chewbacca (555)")
    end

    it 'gives name, indicates phone unknown, when just name set' do
      user = create(:user, name: 'Chewbacca')

      expect(user.info).to eq("Chewbacca (phone number unknown)")
    end
  end
end
