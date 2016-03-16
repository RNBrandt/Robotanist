require 'rails_helper'
require 'spec_helper'

RSpec.describe Genus, type: :model do
  let(:valid_genus) do
    Genus.new(scientific_name: 'Caniscactus', common_name: 'Dogcactus', description: "Just what you'd think")
  end

  after(:all) {valid_genus.destroy}

  describe 'object create' do
    it 'saves with valid data' do
      expect{valid_genus.save}.to change{Genus.count}.by(1)
    end
  end
end