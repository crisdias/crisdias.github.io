def cloudinary_upload(data)
  #### CLOUDINARY UPLOAD

  puts ""
  puts "Uploading image to Cloudinary..."

  Cloudinary.config_from_url(ENV['CLOUDINARY_URL'])
  Cloudinary.config do |config|
    config.secure = true
  end

  sem_artigos = remove_artigos(data['kebab'])
  filename = sem_artigos
  folder = "crisdicas/#{sem_artigos[0]}/"

  if !(data['image'].include? 'SEM IMAGEM')
    upload=Cloudinary::Uploader.upload(data['image'],
      resource_type: :image,
      folder: folder,
      use_filename: false,
      filename_override: filename,
      public_id: filename,
      overwrite: true
    )
    return upload['public_id'].gsub('crisdicas/', '') + '.jpg'
  end

  return ""


end
