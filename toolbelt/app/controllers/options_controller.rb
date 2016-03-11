class OptionsController < ApplicationController
  def index
    @Options = Option.where(parent_id:nil)
  end

  def show
    @option = Option.find(params[:id])
    @children = @option.children
  end
