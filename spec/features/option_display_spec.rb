require 'rails_helper'
require 'spec_helper'

describe Option, :js => true do

  # before(:all) { Option.destroy_all }

  # let!(:option) { Option.create(text: "Is it a plant?", head: "root") }
  # let!(:option_prime) { Option.create(text: "Is it a dog?", head: "root") }
  # let!(:child) { option.children.create(text: "Bulblets") }
  # let!(:child_prime) { option.children.create(text: "That's right, Bulblets") }
  # let!(:dog) { option_prime.children.create(text: "Maybe it's a dogplant?") }
  # let!(:dog_prime) { option_prime.children.create(text: "It's almost certainly a dogplant.") }

  before(:each) {
    Capybara.current_window.resize_to(1400,900)
    visit root_path
  }

  context 'index page' do
    it 'displays page title' do
      expect(page).to have_content("BEGIN")
    end

    describe 'left option display' do
      before(:each) {(page).find('#arrowLeft').click}

      it "renders the option template upon navigation" do
        expect(page.find("#dataCarousel")).to have_content("cleistogamous")
      end
      it "does not render incorrect tree navigation" do
        expect(page.find("#dataCarousel")).to_not have_content("Bulblets")
      end
      it "reloads the previous data when 'step back' button is clicked" do
        (page).find('#arrowStepLeft').click
        expect(page).to have_content('examination')
      end
    end

    describe 'right option display' do
      before(:each) {(page).find('#arrowRight').click}

      it "renders the option template upon navigation" do
        expect(page.find("#dataCarousel")).to have_content("Bulblets")
      end
      it "does not render incorrect tree navigation" do
        expect(page.find("#dataCarousel")).to_not have_content("cleistogamous")
      end
      it "reloads the previous data when 'step back' button is clicked" do
        (page).find('#arrowStepRight').click
        expect(page).to have_content('examination')
      end
    end

    # describe 'info tab' do
    #   before(:each) do
    #     click_on('Angiosperm')
    #   end

    #   it "loads info from Wikipedia API" do
    #     click_on('Angiosperm')
    #     expect(page.find('#wikipediaDiv')).to have_content("angiosperm")
    #   end

    #   it "can be closed" do
    #     click_on('close')
    #     expect(page).to_not have_content('angiosperm')
    #   end
    # end

    # describe 'photo gallery' do
    #   it "displays images from Flickr API" do
    #     click_on('Angiosperm')
    #     click_on('Flickr Photos')
    #     expect(page.find('#flickrDiv')).to have_selector('img')
    #   end
    # end

    # describe 'smart search' do
    #   before(:each) do
    #     fill_in 'autocomplete-ajax', with: 'ly'
    #   end

    #   it 'displays dropdown of auto-complete options' do
    #     expect(page).to have_content('Lycopodiaceae')
    #   end

    #   # it 'allows user to navigate to associated page' do
    #   #   click_on('Search')
    #   #   expect(page).to have_content('....')
    #   # end
    # end
  end

end