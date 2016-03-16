class SpeciesController < ApplicationController

  def index
    @species = Species.all
  end

  def show
    @child_obj = Species.find(params[:id])
    caps = @child_obj.description.match(/^[A-Z]+/).to_s
    if caps
      @status = @child_obj.description[0...(caps.length-1)]
      @description = @child_obj.description[(caps.length-1)..-1]
    end
    @col_width = 6
    @col_width = 4 if @child_obj.image_url
  end
end

