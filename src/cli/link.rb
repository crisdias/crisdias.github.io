def link_grabber(link)
    data= {}


    doc = Nokogiri::HTML(URI.open(link))

    if doc.css("meta[property='og:image']").present?
        image = doc.css("meta[property='og:image']").first['content']
    else
        image = "SEM IMAGEM"
    end

    if doc.css("meta[name='author']").present?
        autor = doc.css("meta[name='author']").first['content']
    elsif doc.css("meta[property='article:author']").present?
        autor = doc.css("meta[property='article:author']").first['content']
    else
        autor = "SEM AUTOR"
    end


    data['linkto'] = link
    data['image'] = image
    data['titulo'] = doc.css("title").first.text
    data['autor'] = autor

    data['categorias'] = 'artigo'
    data['authors_txt'] = data['autor']
    data['authors_array'] = [data['autor']]
    data['kebab'] = data['titulo'].to_s.to_slug.normalize().to_s
    data['datetime'] = Time.now.strftime("%Y-%m-%d %H:%M:%S")
    data['verbo'] = 'Leia'

    return data
end