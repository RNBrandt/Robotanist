require 'nokogiri'

class Option
  include Mongoid::Document
  include Mongoid::Tree
  include Mongoid::Tree::Ordering
  field :text, type: String
  field :head, type: String
end

