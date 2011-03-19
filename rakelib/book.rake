require 'pp'
$LOAD_PATH << 'lib'
require 'book'
require 'filelist'

namespace :book do
	directory 'build/raw_html'

	def books
		@books ||= BookOfMark::Book.new FileList.new('*.book')[0]
	end

	task :raw_html => 'build/raw_html' do
		books.source.each do |source|
			target = 'build/raw_html/' + source.ext('html')
			if not (File.file? target) or File.mtime("source/#{source}") > File.mtime(target)
				pp "todo #{source} => #{target}"
				m = Maruku.new IO.read("source/#{source}")
				File.open(target, 'w') do |f|
					f.write m.to_html
				end
			end
		end
	end
	task :clean do
		rm_rf 'build'
	end
	task :index do
		pp books.to_toc
	end

end