require 'bluecloth'

namespace :markdown do
	task :test do
		Dir.glob('*.{md,mkd,markdown}') do |path|
			html = File.basename(path, '.' + path.split('.')[-1]) + '.html'
			if not File.exist? html or File.atime(path) > File.atime(html)
				puts path
				f = File.new html, 'w'
				f.write BlueCloth::new( IO.read(path) ).to_html
				f.close
			end
		end
	end
end

task :default => 'markdown:test'