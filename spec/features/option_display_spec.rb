require 'rails_helper'
require 'spec_helper'

describe Option, :js => true do

  let(:option) { Option.create(text: "Is it a plant?", head: "root") }
  let(:option_prime) { Option.create(text: "Is it a dog?", head: "root") }
  # let(:options) { Option.where(head: 'root') }

  context 'a user' do
    it 'can see the page title' do
      visit root_path
      expect(page).to have_content("welcome to Botanist Toolbelt")
    end

    describe 'option display' do
      # let(:arrow) { page.find_link('#view-index') }
      it "renders the option template" do
        # click_on arrow
        # within ".item" do
        #   first(:link, "Agree").click
        # end
        # click_on('&#9664; Continue Here')
        click_on('◀ Continue Here')
        expect(page).to render_template("layouts/carousel")
      end
    end
  end

end