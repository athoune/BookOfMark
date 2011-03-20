require 'pp'
require 'json'
require 'erb'
require 'rubygems'
require 'maruku'
$LOAD_PATH << 'lib'
require 'book'
require 'filelist'
require 'html2index'

namespace :book do

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

	namespace :html do
		directory 'build/raw_html'
		directory 'build/one_html'

		task :raw_html => 'build/raw_html' do
			book.toc.each do |source|
				target = 'build/raw_html/' + source.ext('html')
				create "source/#{source}" => target do
					info "converting #{source} => #{target}"
					m = Maruku.new IO.read("source/#{source}")
					File.open(target, 'w') do |f|
						f.write m.to_html
					end
				end
			end
		end
		task :index => :raw_html do
			IDX = "build/raw_html/index.json"
			create book.html_files => IDX do
				info "new index"
				buffer = ''
				book.html_files.each{ |html| buffer += IO.read(html) + "\n"}
				File.open(IDX, 'w') do |f|
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
		
	end
	
	namespace :latex do
		directory 'build/raw_latex'

		task :raw_latex => 'build/raw_latex' do
			book.toc.each do |source|
				target = 'build/raw_latex/' + source.ext('tex')
				create "source/#{source}" => target do
					info "converting #{source} => #{target}"
					m = Maruku.new IO.read("source/#{source}")
					File.open(target, 'w') do |f|
						f.write m.to_latex
					end
				end
			end
		end
		task :latex => :raw_latex do
			create book.path => 'build/raw_latex/__index.tex' do
				File.open('build/raw_latex/__index.tex', 'w') do |f|
					f.write ERB.new(IO.read 'lib/template/book.tex.rhtml').result(book.getBinding)
				end
			end
		end
		task :pdf => :latex do
			create 'build/raw_latex/__index.tex' => 'build/raw_latex/__index.pdf'  do
				Dir.chdir 'build/raw_latex' do
					sh 'pdflatex __index.tex'
				end
			end
		end
	end

	desc "Clean build files"
	task :clean do
		rm_rf 'build'
	end

	task :helpindex => 'html:one_html' do
		create 'build/one_html/one_html.helpindex' => 'build/one_html/index.html' do
			sh "hiutil -C build/one_html"
		end
	end
	
	task :img => 'html:one_html' do
		i = Html2index.imgs IO.read('build/one_html/index.html')
		pp i.imgs
	end

	desc "Build pdf"
	task :pdf => 'latex:pdf'
end