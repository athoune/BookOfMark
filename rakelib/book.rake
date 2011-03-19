require 'pp'
require 'json'
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

	task :index => :raw_html do
		idx = "build/raw_html/index.json"
		f = FileList.new books.source.map {|source| 'build/raw_html/' + source.ext('html')}
		if not(File.file? idx) or File.mtime(idx) < f.lastModification
			pp "new index"
			buffer = ''
			books.source.each do |source|
				target = 'build/raw_html/' + source.ext('html')
				buffer += IO.read(target) + "\n"
			end
			File.open(idx, 'w') do |f|
				f.write Html2index.parse(buffer).tree.to_json
			end
		end
	end

end