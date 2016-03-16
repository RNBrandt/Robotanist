require 'rails_helper'
require 'spec_helper'

RSpec.describe Family, type: :model do
  let(:valid_family) do
    Family.new(scientific_name: 'Caniscactus', common_name: 'Dogcactus', description: "Just what you'd think")
  end

  after(:all) {valid_family.destroy}

  describe 'object create' do
    it 'saves with valid data' do
      expect{valid_family.save}.to change{Family.count}.by(1)
    end
  end
end
