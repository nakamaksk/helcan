require 'rails_helper'

RSpec.describe Person, type: :model do
  describe '#weights_by_day' do
    let(:person) {
      person = nil
      Timecop.freeze("2022/1/1") {
        person = Person.create(
          last_name: "田中", first_name: "太郎", weight: 70.0
        )
      }
      person
    }
    let(:weights_by_day) { person.weights_by_day }

    before do
      Timecop.freeze("2022/1/10") {
        person.update(weight: 71.0)
      }

      Timecop.freeze("2022/1/15") {
        person.update(weight: 69.5)
      }
    end

    it 'returns Hash type' do
      expect(weights_by_day.class).to eq Hash
    end

    let(:range_of_day) { ('2022/1/1'.to_date..'2022/1/15'.to_date) }
    it 'returns correct counts' do
      expect(weights_by_day.count).to eq range_of_day.count
    end
  end
end
