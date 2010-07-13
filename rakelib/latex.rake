require 'nokogiri'
require 'lib/html2tex'

tag :h1, 'section'
tag :h2, 'subsection'

begin_end_tag :code, 'verbatim'
begin_end_tag :ul,   'enumerate'

empty_tag :li, 'item'

tag :em,     'textit'
tag :strong, 'textbf'

namespace :latex do
	desc "html vers latex"
	rule '.tex' => '.html' do |t|
		p t.name
		f = File.open(t.source)
		#doc = Nokogiri::HTML(f)
		#p doc.root()
		puts parse(f.read)
		f.close
		# out = File.open(t.name, 'w')
		# out.write 'prout'
		# out.close
	end
	
	task :dump do
		puts @tags.to_yaml
	end
end

task :default => 'README.tex'