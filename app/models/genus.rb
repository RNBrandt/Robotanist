class Genus
  include Mongoid::Document
  include Mongoid::Tree
  include Mongoid::Search
  field :scientific_name, type: String
  field :common_name, type: String
  field :description, type: String
  search_in :scientific_name, :common_name
end

# Index Mongoid::Search by running be rake mongoid_search:index