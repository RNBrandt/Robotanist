class FamiliesController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    @families = Family.all
  end

  def show
    @family = Family.find(params[:id])
  end

  def search
    search_id = Family.find_by(scientific_name: params[:search_key]).id
    redirect_to family_path(id: search_id)
  end
end