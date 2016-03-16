class GlossaryController < ApplicationController

  def index
    @glossaries = Glossary.all
    render layout: "detail"

  end

  def show
    @definition = Glossary.limit(1).where(word: params[:id]).pluck(:definition)
    if request.xhr?
      render partial: 'glossary', locals: { definition: @definition }, layout: false
    else
      render layout: "detail"
    end

    
  end

end
