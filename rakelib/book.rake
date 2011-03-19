require 'pp'
require 'json'
$LOAD_PATH << 'lib'
require 'book'
require 'filelist'

namespace :book do
	directory 'build/raw_html'
	directory 'build/one_html'

	def book
		@book ||= BookOfMark::Book.new FileList.new('*.book')[0]
	end

	def info txt
		puts "[Info] #{txt}"
	end

	def create st
		source = st.keys[0]
		target = st[source]
		mtime = (source.class == FileList) ? source.lastModification : File.mtime(source)
		yield self if not(File.file? target) or mtime > File.mtime(target)
	end

	task :raw_html => 'build/raw_html' do
		book.toc.each do |source|
			target = 'build/raw_html/' + source.ext('html')
			create target => "source/#{source}" do
				info "converting #{source} => #{target}"
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
		f = book.html_files
		create f => idx do
			info "new index"
			buffer = ''
			f.each do |html|
				buffer += IO.read(html) + "\n"
			end
			File.open(idx, 'w') do |f|
				f.write Html2index.parse(buffer).tree.to_json
			end
		end
	end

	task :one_html => [:index, 'build/one_html'] do
		create 'build/raw_html/index.json' => 'build/one_html/index.html' do
			File.open('build/one_html/index.html', 'w') do |f|
				f.write '<html><head><title>'
				f.write book.title
				f.write '</title></head><head>'
				f.write '<body>'
				book.html_files.each{ |html| f.write IO.read(html)}
				f.write '</body>'
			end
		end
	end

	task :helpindex => :one_html do
		create 'build/one_html/one_html.helpindex' => 'build/one_html/index.html' do
			sh "hiutil -C build/one_html"
		end
	end

end