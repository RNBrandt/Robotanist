# Controller for all Options objects
class OptionsController < ApplicationController

  def index
    @options = Option.where(head:'root', page:"/IJM_fam_key.html")
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
    @children = [@option.children[1], @option.children[0]]
    @parent = @option.parent
    @col_width = 6
    @image = ''
    @credit = nil

    if @option.child_obj != {}

      obj_type = @option.child_obj.keys[0]
      obj_id = @option.child_obj[obj_type]
      if obj_type == "Species"
        @child_obj = Species.find(obj_id)
        @description = @child_obj.description
        if @child_obj.image_url
          @image = @child_obj.image_url
          @credit = @child_obj.image_credit
          @col_width = 4
        end

        caps = @description.match(/^[A-Z]+/).to_s

        if caps
          @status = "Status: " + @description[0...(caps.length-1)]
          @description = @description[(caps.length-1)..-1]
        end

      elsif obj_type == "Family"
        @child_obj = Family.find(obj_id)
        @description = @child_obj.description
      else
        @child_obj = Genus.find(obj_id)
        @description = @child_obj.description
      end
    end

    if request.xhr?
      if @child_obj
        render partial: 'layouts/carousel_end', locals: { option: @option, child_obj: @child_obj, status: @status, description: @description, col_width: @col_width, image: @image, image_credit: @credit }, layout: false
      else
        render partial: 'layouts/carousel', locals: { options: @children }, layout: false
      end
    else
      if obj_type == "Family"
          redirect_to family_path(@family)
      elsif obj_type == "Genus"
        redirect_to genus_path(@genus)
      elsif obj_type == "Species"
        redirect_to species_path(@species)
      end
    end

  end

  def continue
    @option = Option.find(params[:id])
    @children = @option.children
    if request.xhr?
    render partial: 'layouts/carousel', locals: { options: @children }, layout: false
    else
      p ("Fix this for non JS")
    end
  end
end

# Option.find_by(child_obj: { "Family" => "56eacfd0c3b5a0f173c413fc"})

# Option.find_by(child_obj: { "Family" => Family.id.to_s })