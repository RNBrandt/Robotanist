def nokogiri_glossary
  glossary_uri = URI('http://ucjeps.berkeley.edu/eflora/glossary.html')
  @glossary_doc = Nokogiri.parse(Net::HTTP.get(glossary_uri))
  @glossary_doc
end

def parse_definitions
  @definitions = []
  @glossary_doc.css('dd').each { |x| @definitions << x.inner_text }
  @definitions
end

def parse_words
  @words = []
  @glossary_doc.css('dt').each { |x| @words << x.inner_text.chomp('.') }
  @words
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
  text_array = text.split(' ')
   p text_array
   words_to_replace = {}
  text_array.each do |word|
    search_word = word.chomp(',').chomp('.').chomp(')').chomp(';').downcase
    if Glossary.where(word: search_word)[0]
      words_to_replace[word] = search_word
    elsif Glossary.where(word: search_word.chomp('s'))[0]
      words_to_replace[word] = search_word.chomp('s')
    end
  end
  words_to_replace.each do |word , search_word|
    entry = Glossary.find_by(word: search_word)
      text_array.each_with_index do |array_word, index|
        if array_word == word
          text_array[index] = "<a href='' data-toggle='tooltip' title='#{entry.definition}'>#{word}</a>"
        end
      end
  end
  return text_array.join(" ")
end

def create_glossary
  nokogiri_glossary
  parse_definitions
  parse_words
  create_glossary_hash
  create_glossary_record
end
