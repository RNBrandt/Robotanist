# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
class Scraper
  include Wombat::Crawler

  base_url "http://ucjeps.berkeley.edu"
  path "/eflora"
end

Wombat.crawl do
  base_url "http://ucjeps.berkeley.edu"
  path "/eflora"
end

