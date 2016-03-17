class Glossary
  include Mongoid::Document
  include Mongoid::Search
  field :word, type: String
  field :definition, type: String
  search_in :word
end
