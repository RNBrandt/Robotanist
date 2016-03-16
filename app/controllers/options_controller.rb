# Controller for all Options objects
class OptionsController < ApplicationController

  def index
    @options = Option.where(head:'root')
    @families = Family.all
    if request.xhr?
      render partial: 'layouts/carousel', locals: { options: @options }, layout: false
    end

    @family_count = Family.all.count
    @species_count = Species.all.count
    @genera_count = Genus.all.count

  end

  def twitter
    client = Twitter::REST::Client.new do |config|

      config.consumer_key        = Rails.application.secrets[:'config.consumer_key']
      config.consumer_secret     = Rails.application.secrets[:'config.consumer_secret']
      config.bearer_token        = Rails.application.secrets[:'config.bearer_token']
    end

    @tweets = client.search(params[:keyword], result_type: "recent").take(20)

    if request.xhr?
      render partial: 'layouts/info_twitter', locals: {tweets: @tweets}, layout: false
    end

  end

  def show
    @option = Option.find(params[:id])
    @children = @option.children
    @parent = @option.parent

    if @option.child_obj != {}
      obj_type = @option.child_obj.keys[0]
      obj_id = @option.child_obj[obj_type] 
      if obj_type == "Species"
        @child_obj = Species.find(obj_id)
      elsif obj_type == "Family"
        @child_obj = Family.find(obj_id)
      else
        @child_obj = Genus.find(obj_id)
      end
    end

    if request.xhr?
      if @child_obj
        render partial: 'layouts/carousel_end', locals: { child_obj: @child_obj }, layout: false
      else
        render partial: 'layouts/carousel', locals: { options: @children }, layout: false
      end
    end

  end
end
