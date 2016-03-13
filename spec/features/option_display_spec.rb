require 'rails_helper'
require 'spec_helper'

describe Option, :js => true do

  before(:all) { Option.destroy_all }

  let!(:option) { Option.create(text: "Is it a plant?", head: "root") }
  let!(:option_prime) { Option.create(text: "Is it a dog?", head: "root") }
  let!(:child) { option.children.create(text: "Bulblets") }
  let!(:child_prime) { option.children.create(text: "That's right, Bulblets") }
  let!(:dog) { option_prime.children.create(text: "Maybe it's a dogplant?") }
  let!(:dog_prime) { option_prime.children.create(text: "It's almost certainly a dogplant.") }

  before(:each) { visit root_path }

  context 'a user' do
    it 'can see the page title' do
      p "SPEC " + ("$" * 80)
      p option
      p option.children
      expect(page).to have_content("welcome to Botanist Toolbelt")
    end

    describe 'option display' do
      it "renders the option template on left navigation" do
        click_on('◀ Continue Here')
        expect(page.find("#dataCarousel")).to have_content("Bulblets")
      end

      it "renders the option template on right navigation" do
        click_on('Continue Here ▶')
        expect(page.find("#dataCarousel")).to have_content("dogplant")
      end
      # it "renders links to navigate further" do
      #   # render :template => "layouts/carousel.html"
      #   rendered.should include("◀ Continue Here")
      # end
    end
  end

end