# Controller for all Options objects
class OptionsController < ApplicationController
  def index
    @options = Option.where(head: 'root')
  end

  def show
    @option = Option.find(params[:id])
    @children = @option.children
    p 'CONTROLLER ' + ('@' * 120)
    p @option
    p @children
    if request.xhr?
      render partial: 'layouts/carouse', locals: { options: @children }, layout: false
    end
  end
end
