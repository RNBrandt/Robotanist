def scrape(url)
  uri = URI(url)
  doc = Nokogiri.parse(Net::HTTP.get(uri))
  blockquote = doc.css('blockquote').inner_text
  dichotomies =  blockquote.split("\n")
  dichotomies.delete("")
  return dichotomies
end

def make_first_nodes(dichotomies, parent_page = nil, parent_key = nil, current_href)
  dichotomies.each do |dichotomy|
    if parent_key == nil
      if dichotomy[0] == "1" && dichotomy[1] == '.'
        first = Option.create(text:dichotomy,page: current_href, head: current_href, key: "1.")
      elsif dichotomy[0] == "1" && dichotomy[1] == "'"
        Option.first.siblings << Option.create(text:add_tool_tip_span(dichotomy),page: current_href, head: current_href, key: "1'")
      end
   else
     p "****************************************"
     parent_option = Option.find_by(page: parent_page, key: parent_key)
     if dichotomy[0] == "1" && dichotomy[1] == '.'
        parent_option.children << Option.create(text:dichotomy,page: current_href, head: current_href, key: "1.")
      elsif dichotomy[0] == "1" && dichotomy[1] == "'"
        parent_option.children << Option.create(text:add_tool_tip_span(dichotomy),page: current_href, head: current_href, key: "1'")
    end
   end
  end
end

def fill_tree(dichotomies, current_href)
  i = 2
  while dichotomies.find {|dic| dic.match(/^#{Regexp.quote(i.to_s)}'/)} != nil
    prime_match = (/^#{Regexp.quote(i.to_s)}'/)
    non_prime_match = (/^#{Regexp.quote(i.to_s)}\./)
    parent_index = dichotomies.find_index {|dic| dic.match(non_prime_match)} - 1
    @text = dichotomies.find {|dic| dic.match(non_prime_match)}
    parent = Option.find_by(page: current_href, key: dichotomies[parent_index][/^([^\s]+)/])
    parent.children << Option.create(text: add_tool_tip_span(@text),page: current_href, key: "#{i}.")
    text_prime = dichotomies.find {|dic| dic.match(prime_match)}
    parent.children << Option.create(text: text_prime, page: current_href, key: "#{i}'")
    i += 1
  end
end

def nokogiri_glossary
  glossary_uri = URI("http://ucjeps.berkeley.edu/eflora/glossary.html")
  @glossary_doc = Nokogiri.parse(Net::HTTP.get(glossary_uri))
  return @glossary_doc
end

def parse_definitions(glossary_doc)
  @definitions = []
  @glossary_doc.css('dd').each {|x| @definitions << x.inner_text}
  return @definitions
end

def parse_words(glossary_doc)
  @words = []
  @glossary_doc.css('dt').each {|x| @words << x.inner_text.chomp('.')}
  return @words
end

def create_glossary_hash
  @glossary = Hash[@words.zip @definitions]
end

def create_glossary_record
  @glossary.each do |word, definition|
    Glossary.create(word: word, definition: definition)
  end
end

def add_tool_tip_span(text)
  text_array = text.split(" ")
  text_array.each do |word|
    search_word = word.chomp(",").chomp(".")
    if Glossary.where(word: search_word)[0]
      entry = Glossary.find_by(word: search_word)
      text.gsub!(/#{Regexp.quote(word)}/, "<span data-tooltip aria-haspopup='true' class='has-tip [tip-top tip-bottom tip-left tip-right] [radius round]' title=#{entry.definition}>#{word}</span>")
    elsif Glossary.where(word: search_word.chomp("s"))[0]
      entry = Glossary.find_by(word: search_word.chomp("s"))
      text.gsub!(/#{Regexp.quote(word)}/, "<span data-tooltip aria-haspopup='true' class='has-tip [tip-top tip-bottom tip-left tip-right] [radius round]' title=#{entry.definition}>#{word}</span>")
    end
  end

  return text
end

def find_links(url)
  uri = URI(url)
  doc = Nokogiri.parse(Net::HTTP.get(uri))
  links = doc.css('blockquote').css('a')
  hrefs = links.map {|link| (link.attribute("href").to_s)}
  useful_hrefs = hrefs.select {|href| href.match(/^\/.*/)}
  return useful_hrefs
end


def find_link_parent_keys(url)
  p_tags = scrape(url)
  tags_with_links = p_tags.select { |txt| txt.match(/(?<=\.\.\.\.\.).*/)}
  parent_keys = tags_with_links.map {|txt| txt.gsub(/\s.+/, '')}
  return parent_keys
end

def make_link_hash(url)
  url#Finds the right link.
  links = find_links(url)
  keys = find_link_parent_keys(url)
  link_hash = Hash[keys.zip links]
  return link_hash
end
