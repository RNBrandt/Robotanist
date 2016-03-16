class SpeciesController < ApplicationController

  def index
    @species = Species.all
  end

  def show
    @species = Species.find(params[:id])
    @col_width = 6
    @col_width = 4 if @species.image_url
    render layout: "detail"
  end
end