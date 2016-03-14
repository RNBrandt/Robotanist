require_relative "../app/helpers/scrape_helpers"
require_relative "../app/helpers/link_helpers"
require_relative "../app/helpers/object_helpers"
Option.destroy_all
Glossary.destroy_all

BASE_URL = "http://ucjeps.berkeley.edu"

@root_href = "/IJM_fam_key.html"

#@parent_url = nil



def scrape_and_make_options(current_href, parent_page=nil, parent_key=nil)
  url = BASE_URL + current_href
  dichotomies = scrape(url)
  make_first_nodes(dichotomies, parent_page, parent_key, current_href )
  fill_tree(dichotomies, current_href)
end

def create_link_objs (url, current_href)
  link_hash = make_link_hash(url)
  link_objs = []
  link_hash.each do |key,href|
    link_objs << Link.new(href, current_href, key)
  end
  return link_objs
end

def recursive_scrape(current_href, parent_page=nil,parent_key=nil)
  p current_href
  url = BASE_URL + current_href
  p_tags = scrape(url)
  if tags_with_links = p_tags.select { |txt| txt.match(/(?<=\.\.\.\.\.).*/)} == []
    return "obj"
  end
  scrape_and_make_options(current_href, parent_page, parent_key)
  links = associate_links(url, current_href)

  links.each do |link|
    recursive_scrape(link.href, link.parent_href, link.parent_key)
  end
end

# url = BASE_URL + @root_href
 recursive_scrape("/IJM_fam_key.html")
# p associate_links('http://ucjeps.berkeley.edu/IJM_fam_key.html', "/IJM_fam_key.html")
