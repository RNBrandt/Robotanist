require_relative "../app/helpers/scrape_helpers"
require_relative "../app/helpers/link_helpers"
require_relative "../app/helpers/object_helpers"
require_relative "../app/helpers/glossary_helpers"
require_relative "../app/helpers/blockquote_class"

#Option.destroy_all
#Glossary.destroy_all
#Species.destroy_all
#Family.destroy_all
#Genus.destroy_all

BASE_URL = "http://ucjeps.berkeley.edu"

@root_href = "/IJM_fam_key.html"

# big_family_hash = {"Asteraceae"=> "/cgi-bin/get_IJM.pl?key=58","Brassicaceae"=>"/cgi-bin/get_IJM.pl?key=70", "Fabaceae"=> "/cgi-bin/get_IJM.pl?key=134", "Poaceae"=> "/cgi-bin/get_IJM.pl?key=223"}

<<<<<<< HEAD
end

#big_family_hash = {"Asteraceae"=> "/cgi-bin/get_IJM.pl?key=58","Brassicaceae"=>"/cgi-bin/get_IJM.pl?key=70", "Fabaceae"=> "/cgi-bin/get_IJM.pl?key=134", "Poaceae"=> "/cgi-bin/get_IJM.pl?key=223"}

#first_blockquote = get_blockquote("/IJM_fam_key.html")
#parser = BlockQuoteParser.new(first_blockquote, "/IJM_fam_key.html")
#create_glossary
recursive_scrape(parser)
scrape_from_families
big_family_hash.each do |name,href|
  big_family_scraper(href, name)
end

=======
# first_blockquote = get_blockquote("/IJM_fam_key.html")
# parser = BlockQuoteParser.new(first_blockquote, "/IJM_fam_key.html")
create_glossary
# recursive_scrape(parser)
# scrape_from_families
# big_family_hash.each do |name,href|
#   big_family_scraper(href, name)
# end
p add_tool_tip_span("8' Specimens with bisexual flowers or with both staminate and pistillate flowers on same or different individuals; plants bisexual, dioecious, or monoecious (occasionally with mixture of bisexual and unisexual flowers)")
>>>>>>> 193f8738dd31ddb6a84d4d0391b011b2a2a054cf
