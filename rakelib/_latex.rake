require 'nokogiri'
require 'lib/html2tex'

Html2tex.tag :h1, 'section'
Html2tex.tag :h2, 'subsection'

Html2tex.begin_end_tag :code, 'verbatim'
Html2tex.begin_end_tag :ul,   'enumerate'

Html2tex.empty_tag :li, 'item'

Html2tex.tag :em,     'textit'
Html2tex.tag :strong, 'textbf'

namespace :latex do
	desc "html vers latex"
	rule '.tex' => '.html' do |t|
		p t.name
		f = File.open(t.source)
		#doc = Nokogiri::HTML(f)
		#p doc.root()
		puts Html2tex.parse(f.read)
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