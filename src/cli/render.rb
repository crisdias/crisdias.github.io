def post_render(data)
    ### LIQUID TEMPLATE

    puts "Rendering Liquid template..."

    template = File.read('./_templates/cli-post.liquid')

    post = Liquid::Template.parse(template) 
    makrdown = post.render(data)            
    puts makrdown

    # write markdown to file

    datetimekebab = Time.now.strftime("%Y-%m-%d")
    saveto = "./_posts/#{datetimekebab}-#{data['kebab']}.md"
    puts "Writing markdown file: #{saveto}"

    File.open(saveto, 'w') { |file| file.write(makrdown) }
end