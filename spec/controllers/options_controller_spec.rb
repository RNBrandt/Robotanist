require 'rails_helper'
require 'spec_helper'

describe OptionsController, :type => :controller do

  before(:all) { Option.destroy_all }

  let(:option) { Option.create(text: "Is it a plant?", head: "root", page: "1", key: "1") }
  let(:child) { option.children.create(text: "Is it a dog?") }

  describe 'get #index' do
    it 'renders question display' do
      get :index
      expect(response).to render_template :index
    end

    it 'displays option objects' do
      get :index
      expect(assigns(:options)).to eq([option])
    end
  end

  describe 'show' do
    it "assigns the requested option as @option" do
      get :show, {:id => option.to_param}
      expect(assigns(:option)).to eq(option)
    end

    it "assigns the children of option as @children" do
      get :show, {:id => option.to_param}
      expect(assigns(:children)).to eq([child])
    end
  end
end