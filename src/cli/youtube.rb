def youtube_grabber(link)
    puts "Pegando dados do YouTube..."

    video_id = nil
    if link.include? 'youtu.be'
        video_id = link.split('youtu.be/')[1].split('?')[0]
    else
        video_id = link.split('v=')[1].split('&')[0]
    end

    data = {}
    data['linkto'] = link
    data['image'] = "https://img.youtube.com/vi/#{video_id}/maxresdefault.jpg"

    
    # get youtube video title from video_id
    doc = Nokogiri::HTML(URI.open(link))
    # puts doc.inner_html
    # exit

    titulo = doc.css('title').text.split('- YouTube')[0].strip
    if doc.inner_html =~ /"ownerChannelName":"(.+?)"/
        data['titulo'] = "#{titulo} — #{$1}"
        data['autor'] = $1
    else
        data['titulo'] = "#{titulo}"
        data['autor'] = "YouTube"
    end

    puts "Título: #{data['titulo']}"
    puts ""

    data['categorias'] = 'tv, youtube'
    data['authors_txt'] = data['autor']
    data['authors_array'] = [data['autor']]
    data['kebab'] = data['titulo'].to_s.to_slug.normalize().to_s
    data['datetime'] = Time.now.strftime("%Y-%m-%d %H:%M:%S")
    data['verbo'] = 'Assista'
    
    

    return data


end