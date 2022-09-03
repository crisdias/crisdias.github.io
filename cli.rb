require 'paapi'
require 'pp'
require 'json'
require 'rubygems'
require 'liquid'
require 'babosa'
require 'cloudinary'
require 'yourls'

require './src/utils.rb'

ASIN = '022668170X'

Paapi.configure do |config|
  config.access_key = ENV['AWS_ACCESS_KEY_ID']
  config.secret_key = ENV['AWS_SECRET_ACCESS_KEY']
  # config.partner_tag = ENV['AMAZON_ASSOCIATES_TRACKING_ID']
  config.partner_market = {br: ENV['AMAZON_ASSOCIATES_TRACKING_ID']}
end

client = Paapi::Client.new(market: :br)

gi = client.get_items(item_ids: ASIN).hash

data = {}

data['linkto'] = gi['ItemsResult']['Items'][0]['DetailPageURL']
data['image'] = gi['ItemsResult']['Items'][0]['Images']['Primary']['Large']['URL']
data['titulo'] = gi['ItemsResult']['Items'][0]['ItemInfo']['Title']['DisplayValue']

list = []
categorias = []
gi['ItemsResult']['Items'][0]['ItemInfo']['ByLineInfo']['Contributors'].each do |a|
  if a['RoleType'] == 'author'
    autor = a['Name'].split(', ').reverse.join(' ').squeeze
    list << autor
    categorias << autor.downcase.to_slug.normalize.to_s
  end
end


data['authors_txt'] = list.join(', ').squeeze
data['authors_array'] = list
data['categorias'] = categorias
data['kebab'] = data['titulo'].to_s.to_slug.normalize().to_s
data['datetime'] = Time.now.strftime("%Y-%m-%d %H:%M:%S")

### SHORT URL
yourls = Yourls::Client.new(ENV['YOURLS_URL'], ENV['YOURLS_TOKEN'])
data['shorturl'] = yourls.shorten(data['linkto']).short_url

pp data
exit


### CLOUDINARY UPLOAD 

Cloudinary.config_from_url(ENV['CLOUDINARY_URL'])
Cloudinary.config do |config|
  config.secure = true
end

sem_artigos = remove_artigos(data['kebab'])
filename = sem_artigos + '.jpg'
folder = "crisdicas/#{sem_artigos[0]}/"

upload=Cloudinary::Uploader.upload(data['image'], 
  resource_type: :image,
  folder: folder,
  use_filename: false, 
  filename_override: filename,
  public_id: filename,
  overwrite: true
  )

data['cloudinary'] = upload['public_id'].gsub('crisdicas/', '')

### LIQUID TEMPLATE

template = File.read('/Users/crisdias/dev/crisdicas/_templates/post.liquid')

post = Liquid::Template.parse(template) 
makrdown = post.render(data)            
puts makrdown





