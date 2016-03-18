def assign_obj_type(url)
  uri = URI(url)
  doc = Nokogiri.parse(Net::HTTP.get(uri))
  main_heading = doc.css("span.pageLargeHeading").inner_text
  sub_heading = doc.css("span.pageMajorHeading").inner_text
  if sub_heading.match(/.+FAMILY/)
    return create_obj(url, Family)
  elsif main_heading.split(" ").length >= 2
    return create_obj(url, Species)
  else
    return create_obj(url, Genus)
  end

end


def create_obj(url, klass)
  uri = URI(url)
  doc = Nokogiri.parse(Net::HTTP.get(uri))
  scientific_name = doc.css("span.pageLargeHeading").inner_text
  common_name = doc.css("span.pageMajorHeading").inner_text
  if klass == Species
    image_grab = doc.css("img")[4].attr('src')
    if image_grab.match(/^[^\/].*\.\w{1,4}$/)
      image_url = image_grab
      image_credit = 'Image courtesy of Jepson Herbarium, UC Berkeley'
      if image_url.match(/jpeg/)
        credit = doc.inner_text.match(/©[\w\d\s\p\'@\&\(\)\+\-\*]+(\p{Ll}(?=\p{Lu}))/)
        image_credit = credit[0] if credit
      end
      p image_url
      p image_credit
    end
  end
  if doc.css("div.bodyText").inner_text == ''
    p "BROKEN!!!!!!!!!!!!"
    return Family.create(description: "Sorry this link is broken")
  else
    description = doc.css("div.bodyText").inner_text.match(/.+?(?=eFlora)/)[0]
  end

  if klass.where(scientific_name: scientific_name) == []
    if klass == Species
      return klass.create(scientific_name: scientific_name, common_name: common_name, description: description, image_url: image_url, image_credit: image_credit)
    else
      return klass.create(scientific_name: scientific_name, common_name: common_name, description: description )
    end
  else
    return klass.find_by(scientific_name: scientific_name)
  end
end
