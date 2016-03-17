class SearchController < ApplicationController

  def index
    @family_results = Family.full_text_search(params[:q], match: :any, allow_empty_search: :true)
    @genus_results = Genus.full_text_search(params[:q], match: :any, allow_empty_search: :true)
    @species_results = Species.full_text_search(params[:q], match: :any, allow_empty_search: :true)
    @glossary_results = Glossary.full_text_search(params[:q], match: :any, allow_empty_search: :true)
    @q = params[:q]
    render layout: "detail"
  end

  private
  def search_params
      params.require(:search).permit(:q)
  end
end


   
