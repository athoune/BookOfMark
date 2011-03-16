begin
  require 'rdiscount'
  BlueCloth = RDiscount
rescue LoadError
  require 'bluecloth'
end

namespace :markdown do

	rule '.html' => ['.md'] do |t|
		puts t.name
		f = File.new t.name, 'w'
		f.write '<div>'
		f.write BlueCloth::new( IO.read(t.source) ).to_html
		f.write '</div>'
		f.close
	end

end

task :default => 'README.html'