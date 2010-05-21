require 'bluecloth'

namespace :markdown do

	rule '.html' => '.md' do |t|
		puts t.name
		f = File.new t.name, 'w'
		f.write BlueCloth::new( IO.read(t.source) ).to_html
		f.close
	end

end

task :default => 'README.html'