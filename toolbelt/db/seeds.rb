# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Option.destroy_all

def scrape
  doc = File.open('/Users/timurcatakli/Dropbox/Corporate/Macbook-15/DevbootCamp/DBC/phase-3/week-3/Botanists-toolbelt/jepson/ucjeps.berkeley.edu/IJM_fam_key.html') { |f| Nokogiri::XML(f)}
  blockquote = doc.css('blockquote').inner_text
  dichotomies =  blockquote.split("\n")
  dichotomies.delete("")
  return dichotomies
end

def make_first_nodes(dichotomies)
  dichotomies.each do |dichotomy|
    if dichotomy[0] == "1" && dichotomy[1] == '.'
      first = Option.create(text:dichotomy, head: "root")
    end
    if dichotomy[0] == "1" && dichotomy[1] == "'"
      Option.first.siblings << Option.create(text:dichotomy, head: "root")
    end
  end
end

def fill_tree(dichotomies)
  i = 2
  while dichotomies.find {|dic| dic.match(/^#{Regexp.quote(i.to_s)}\./)} != nil
    parent_index = dichotomies.find_index {|dic| dic.match(/^#{Regexp.quote(i.to_s)}\./)} - 1
    text = dichotomies.find {|dic| dic.match(/^#{Regexp.quote(i.to_s)}\./)}
    parent = Option.find_by(text: dichotomies[parent_index])
    parent.children << Option.create(text: text)
    text_prime = dichotomies.find {|dic| dic.match(/^#{Regexp.quote(i.to_s)}'/)}
    parent.children << Option.create(text: text_prime)
    i += 1
  end
end

dichotomies = scrape


make_first_nodes(dichotomies)

fill_tree(dichotomies)


