require 'rails_helper'

RSpec.describe Person, type: :model do
  describe '#weights_by_day' do
    let(:person) { create :person }
    it 'should be exsits' do
      expect(person).to be_truthy
    end
  end
end
