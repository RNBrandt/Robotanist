Option.destroy_all
# key_site variable should be dynamically created and sent in
key_site = '/Users/apprentice/Desktop/pete/Jepson-2/ucjeps.berkeley.edu/IJM_fam_key.html'
def scrape(key_site)
  doc = File.open(key_site) { |f| Nokogiri::XML(f)}
  blockquote = doc.css('blockquote').inner_text
  dichotomies =  blockquote.split("\n")
  dichotomies.delete("")
  return dichotomies
end

def make_first_nodes(dichotomies)
  dichotomies.each do |dichotomy|
    if dichotomy[0] == "1" && dichotomy[1] == '.'
      first = Option.create(text:dichotomy, head: "root")
    elsif dichotomy[0] == "1" && dichotomy[1] == "'"
      Option.first.siblings << Option.create(text:dichotomy, head: "root")
    end
  end
end

def fill_tree(dichotomies)
  i = 2
  while dichotomies.find {|dic| dic.match(/^#{Regexp.quote(i.to_s)}'/)} != nil
    prime_match = (/^#{Regexp.quote(i.to_s)}'/)
    non_prime_match = (/^#{Regexp.quote(i.to_s)}\./)
    parent_index = dichotomies.find_index {|dic| dic.match(non_prime_match)} - 1 # finds the index the current option, and subtracts one to find it's parent, this is an inherent pattern to dichotomous keys.
    text = dichotomies.find {|dic| dic.match(non_prime_match)} #adds the text of the option to the variable.
    parent = Option.find_by(text: dichotomies[parent_index]) #finds the parent object using the parent_index variable assigned earlier.
    parent.children << Option.create(text: text) #creates a new instance of an option and adding it as a child of the parent
    text_prime = dichotomies.find {|dic| dic.match(prime_match)} # finds the prime version, of the recently created Option instance.
    parent.children << Option.create(text: text_prime) # Adds previous line as a child of the parent.
    i += 1
  end
end

def scrape_glossary
  glossary_uri = URI("http://ucjeps.berkeley.edu/eflora/glossary.html")
  glossary_doc = Nokogiri.parse(Net::HTTP.get(glossary_uri))
  definitions = []
  glossary_doc.css('dd').each {|x| definitions << x.inner_text}
  words = glossary_doc.css('dt').inner_text
  p definitions
end

# dichotomies = scrape(key_site)

# make_first_nodes(dichotomies)

# fill_tree(dichotomies)

scrape_glossary

