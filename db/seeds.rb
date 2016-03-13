require_relative "../app/helpers/scrape_helpers"

Option.destroy_all
Glossary.destroy_all



BASE_URL = '/Users/apprentice/Desktop/pete/Jepson-2/ucjeps.berkeley.edu'

@href = "/IJM_fam_key.html"

def scrape_and_find_links(href)
  url = BASE_URL + href
  dichotomies = scrape(url)
  make_first_nodes(dichotomies)
  fill_tree(dichotomies)
  find_links(url)
end


scrape_and_find_links(@href)

