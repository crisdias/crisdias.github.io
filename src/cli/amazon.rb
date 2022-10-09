def amazon_grabber(asin)
    puts "Pegando dados da Amazon... #{asin}"
    puts ""

    Paapi.configure do |config|
    config.access_key = ENV['AWS_ACCESS_KEY_ID']
    config.secret_key = ENV['AWS_SECRET_ACCESS_KEY']
    # config.partner_tag = ENV['AMAZON_ASSOCIATES_TRACKING_ID']
    config.partner_market = {br: ENV['AMAZON_ASSOCIATES_TRACKING_ID']}
    end
    
    client = Paapi::Client.new(market: :br)
    
    gi = client.get_items(item_ids: asin).hash

    data = {}
    
    data['linkto'] = gi['ItemsResult']['Items'][0]['DetailPageURL']
    data['image'] = gi['ItemsResult']['Items'][0]['Images']['Primary']['Large']['URL']
    data['titulo'] = gi['ItemsResult']['Items'][0]['ItemInfo']['Title']['DisplayValue']
    
    list = []
    categorias = ['livro', 'NÃO-FICÇÃO']
    gi['ItemsResult']['Items'][0]['ItemInfo']['ByLineInfo']['Contributors'].each do |a|
    if a['RoleType'] == 'author'
        autor = a['Name'].split(', ').reverse.join(' ').strip
        list << autor
        categorias << autor.downcase.to_slug.normalize.to_s
    end
    end
    
    
    data['authors_txt'] = list.join(', ').strip
    data['authors_array'] = list
    data['categorias'] = categorias.join(', ').strip
    data['kebab'] = data['titulo'].to_s.to_slug.normalize().to_s
    data['datetime'] = Time.now.strftime("%Y-%m-%d %H:%M:%S")
    data['verbo'] = 'Leia'
    
    
    
    return data
end
