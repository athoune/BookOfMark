require 'pp'
require 'json'
require 'erb'
require 'rubygems'
require 'maruku'
$LOAD_PATH << 'lib'
require 'book'
require 'filelist'
require 'html2index'
require 'latex'
require 'filter'

namespace :book do
	include BookOfMark

	def info txt
		puts "[Info] #{txt}"
	end

	namespace :html do
		directory 'build/raw_html'
		directory 'build/one_html'
		directory 'build/ditaa'

		task :raw_html => 'build/raw_html' do
			md2html do |doc|
				6.times do |i|
					doc.css("h#{i}").each do |h|
						h.before "<a name=#{h.text}></a>"
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
				template 'lib/template/one_html.rhtml', book.getBinding, 'build/one_html/index.html'
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
			MaRuKu::Out::Latex::Medias.each do |media|
				create "source/#{media}" => "build/raw_latex/#{media}" do
					cp "source/#{media}", "build/raw_latex/#{media}"
				end
			end
		end
		task :latex => :raw_latex do
			create book.path => 'build/raw_latex/__index.tex' do
				template 'lib/template/book.tex.rhtml', book.getBinding, 'build/raw_latex/__index.tex'
			end
		end
		task :pdf => :latex do
			create FileList.new('build/raw_latex/*.tex') => 'build/raw_latex/__index.pdf' do
				Dir.chdir 'build/raw_latex' do
					2.times do
						sh 'pdflatex __index.tex'
					end
				end
			end
		end
	end

	namespace :ditaa do
		task :convert => 'build/ditaa' do
			Dir.chdir 'source/' do
				FileList.new('*.ditaa').each do |ditaa|
					target = "../build/ditaa/" + ditaa.ext('png')
					create ditaa => target do
						sh "ditaa #{ditaa} #{target}"
					end
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
	
	namespace :pdf do
		task :open => '^pdf' do
			sh "open build/raw_latex/__index.pdf"
		end
	end
end