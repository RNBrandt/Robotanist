class SearchController < ApplicationController

  def index
    if params[:q] != ''
      @family_results = Family.full_text_search(params[:q], match: :any, allow_empty_search: :false)
      @genus_results = Genus.full_text_search(params[:q], match: :any, allow_empty_search: :false)
      @species_results = Species.full_text_search(params[:q], match: :any, allow_empty_search: :false)
      @glossary_results = Glossary.full_text_search(params[:q], match: :any, allow_empty_search: :false)
    end
    @q = params[:q]
    # render layout: "detail"
    # respond_to do |format|
      # format.html {  render :json => render_to_string('_tab_partial.html.erb', layout: false) }
      render :partial => 'search/tab_partial', content_type: 'text/html', layout: false
    # end
  end

  private
  def search_params
      params.require(:search).permit(:q)
  end
end



