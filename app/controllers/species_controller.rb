class SpeciesController < ApplicationController

  def index
    @species = Species.all
  end

  def show
    @species = Species.find(params[:id])
    caps = @species.description.match(/^[A-Z]+/).to_s
    if caps
      @status = @species.description[0...(caps.length-1)]
      @description = @species.description[(caps.length-1)..-1]
    end
    @col_width = 6
    @col_width = 4 if @species.image_url
    render layout: "detail"
  end

end

