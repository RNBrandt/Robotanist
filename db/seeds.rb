require_relative "../app/helpers/scrape_helpers"
require_relative "../app/helpers/link_helpers"

Option.destroy_all
Glossary.destroy_all

BASE_URL = "http://ucjeps.berkeley.edu"

@current_href = "/IJM_fam_key.html"

#@parent_url = nil



def scrape_and_find_links(current_href, parent_page=nil, parent_key=nil)
  url = BASE_URL + current_href
  dichotomies = scrape(url)
  make_first_nodes(dichotomies, parent_page, parent_key, current_href)
  fill_tree(dichotomies, current_href)
  return find_links(url)
end

def create_link_objs (url)
  link_hash = make_link_hash(url)
  link_objs = []
  link_hash.each do |key,href|
    link_objs << Link.new(href, @current_href, key)
  end
  return link_objs
end

def recursive_scrape(href, parent_page=nil,parent_key=nil)
  p BASE_URL
  p href
  url = BASE_URL + href
  p_tags = scrape(url)
  if tags_with_links = p_tags.select { |txt| txt.match(/(?<=\.\.\.\.\.).*/)} == []
    return "done"
  end
  #if page has no links with .....
  #return

  scrape_and_find_links(href, parent_page, parent_key)
  p links = create_link_objs(url)

  links.each do |link|
    recursive_scrape(link.href, link.parent_href, link.parent_key)
  end

end

def assign_obj_type(url)
  uri = URI(url)
  doc = Nokogiri.parse(Net::HTTP.get(uri))
  main_heading = doc.css("span.pageLargeHeading").inner_text
  sub_heading = doc.css("span.pageMajorHeading").inner_text
  if main_heading.split(" ").length >= 2
    return create_obj(url, Species)
  elsif sub_heading.match(/.+FAMILY/)
    return create_obj(url, Family)
  else
    return create_obj(url, Genus)
  end

end


def create_obj(url, klass)
  uri = URI(url)
  doc = Nokogiri.parse(Net::HTTP.get(uri))
  scientific_name = doc.css("span.pageLargeHeading").inner_text
  common_name = doc.css("span.pageMajorHeading").inner_text
  description = doc.css("div.bodyText").inner_text.match(/.+?(?=eFlora)/)[0]
  return klass.create(scientific_name: scientific_name, common_name: common_name, description: description)
end



p assign_obj_type('http://ucjeps.berkeley.edu/eflora/eflora_display.php?tid=33989')

p assign_obj_type("http://ucjeps.berkeley.edu/eflora/eflora_display.php?tid=34")

p assign_obj_type("http://ucjeps.berkeley.edu/eflora/eflora_display.php?tid=10193")


