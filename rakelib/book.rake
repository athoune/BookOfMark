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
	directory 'build/medias'

	def info txt
		puts "[Info] #{txt}"
	end

	task :medias do
		FileList['source/**/*.png'].each do |media|
			cp media, 'build/medias/'
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
	
end