require 'nokogiri'
require 'lib/html2tex'

tagblock :code, 'verbatim'

tagblock :ul, 'enumerate'

tagmark :li, 'item'

tag :em, 'textit'

namespace :latex do
	desc "html vers latex"
	rule '.tex' => '.html' do |t|
		p t.name
		f = File.open(t.source)
		doc = Nokogiri::HTML(f)
		p doc.root()
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