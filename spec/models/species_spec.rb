require 'rails_helper'
require 'spec_helper'

RSpec.describe Species, type: :model do
  let(:valid_species) do
    Species.new(scientific_name: 'Canis cactus', common_name: 'Dogcactus', description: "Just what you'd think", image_url: 'fakejepson.com')
  end

  after(:all) {valid_species.destroy}

  describe 'object create' do
    it 'saves with valid data' do
      expect{valid_species.save}.to change{Species.count}.by(1)
    end
  end
end