# util funcitons
def remove_artigos(str)
  arts = ['a-', 'as-', 'o-', 'os-', 'the-']
  arts.each do |art|
    str = str.gsub(/^#{art}/, '')
  end
  return str
end