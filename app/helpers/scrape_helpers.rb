require "pp"

def get_doc(href)
  url = BASE_URL + href
  uri = URI(url)
  doc = Nokogiri.parse(Net::HTTP.get(uri))
end

def get_blockquote(href)
 doc = get_doc(href)
 blockquote = doc.css("blockquote")
end


def create_option(dichotomy, current_href, head, key)
  Option.create(text: add_tool_tip_span(dichotomy), page: current_href, head: head, key: key, child_obj:{})
end

def big_family_scraper(href, family_name)
  p "Doing shhhhtuff"
  blockquotes = get_blockquote(href)
  blockquotes = blockquotes.select { |block| block.inner_text.match(/^1/)}
  first_parser = KlassParser.new(blockquotes.shift, href, {"klass_name"=> family_name, "klass" => "Family"})
  first_parser
  first_parser.scrape_text
  first_parser.dichotomies
  key_to_groups = first_parser.group_key_hash
  recursive_scrape(first_parser)
  embedded_links = first_parser.embedded_group_links
  if embedded_links.length > blockquotes.length
    blockquotes[1] = blockquotes[1], blockquotes[1]
    blockquotes.flatten!
  end
  embedded_link_hash = Hash[embedded_links.zip(blockquotes)]
  embedded_link_hash.each do |link, blockquote|
    new_parser = BlockQuoteParser.new(blockquote, link.href, { parent_page: link.parent_href, parent_key: link.parent_key })
    recursive_scrape(new_parser)
  end
end


def get_family_links
  href = "/eflora/key_list.html"
  doc = get_doc(href)
  table_data = doc.css("ol")
  family_names = table_data.inner_text.split("\n").map! {|name| name.strip}
  family_names.shift
  links = doc.css("ol").css("a").map { |link| (link.attribute('href').to_s) }
  family_link_hash = Hash[family_names.zip(links)]
  to_delete = ["Asteraceae", "Fabaceae", "Poaceae", "Brassicaceae", "Myrsinaceae"]
  family_link_hash.delete_if { |key, value| to_delete.include?(key)}
end



def recursive_scrape(parser)
  p "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
  p parser.href
  parser.scrape_text
  if parser.find_dichotomies_with_links == []
    new_url = get_redirect(BASE_URL + parser.href)
    new_url = [BASE_URL + parser.href] if new_url == []
    parent_option = Option.find_by(page:parser.parent_page, key: parser.parent_key)
    child = assign_obj_type(new_url[0])
    p '_____________________________'
    p child.id.to_s
    parent_option.update_attribute(:child_obj, {child.class.to_s => child.id.to_s})
    parent_option.save
    step_through_genus(parser)
  end
  parser.make_first_node
  parser.fill_tree
  links = parser.create_link_obj
  links.each do |link|
    blockquote = get_blockquote(link.href)
    new_parser = BlockQuoteParser.new(blockquote, link.href, {parent_page: link.parent_href, parent_key: link.parent_key})
    recursive_scrape(new_parser)
  end
end

def scrape_from_families
  link_hash = get_family_links
  link_hash.each do |family_name, href|
     blockquote = get_blockquote(href)
     parser = KlassParser.new(blockquote, href, options= { "klass_name" => family_name, "klass" => Family })
     recursive_scrape(parser)
  end
end

def step_through_genus(parser)
  new_url = get_redirect(BASE_URL + parser.href)
  new_url = [BASE_URL + parser.href] if new_url == []
  new_href = new_url[0][26..-1]
  doc = get_doc(new_href)
  tables = doc.css("table")
  main_heading = doc.css("span.pageLargeHeading").inner_text
  sub_heading = doc.css("span.pageMajorHeading").inner_text
  if main_heading.split(" ").length == 1 && !sub_heading.match(/.+FAMILY/)
    #check for key to button if it exists get link
    a_tags =  doc.css('a')
    key_to = a_tags.select { |a| a.inner_text.match(/^Key to .*/)}
    if key_to[1]
      key_to_href = key_to[1].attribute('href').value[26..-1]
      new_blockquote = get_blockquote(key_to_href)

      new_parser = KlassParser.new(new_blockquote, key_to_href, {"klass_name" => main_heading, "klass" => Genus})
      recursive_scrape(new_parser)
    else
      select_options = doc.css('option')
      href_extention = select_options[1].attribute('value').value
      species_href = "/eflora/#{href_extention}"
      new_blockquote = get_blockquote(species_href)
      genus = Genus.find_by(scientific_name: main_heading)
      parent = Option.find_by(child_obj:{"Genus" => genus.id.to_s})
      new_parser = KlassParser.new(new_blockquote, species_href, {"klass_name" => main_heading, "klass" => Genus, parent_page: parent.page, parent_key: parent.key})
      recursive_scrape(new_parser)
    end

  end

end










