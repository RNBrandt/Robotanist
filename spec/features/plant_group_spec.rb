require 'rails_helper'
require 'spec_helper'

describe Option, :js => true do

  before(:each) {
    Capybara.current_window.resize_to(1400,900)
    visit root_path
  }

  context 'plant groups' do

    describe 'carousel navigation' do
      before(:each) {(page).find('#arrowLeft').click}

      it 'renders family group template' do
        (page).find('#arrowRight').click
        (page).find('#arrowLeft').click
        (page).find('#arrowLeft').click
        (page).find('#arrowLeft').click
        expect(page).to have_content('HORSETAIL')
      end
    end

  end
end