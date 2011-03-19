require 'rubygems'
require 'yaml'
require 'rake'

module BookOfMark
	class Book
		attr :folder
		#read a .book description
		def initialize description
			@md = nil
			@path = description
			folder = description.split('/')
			if folder.length == 1
				@folder = '.'
			else
				@folder = folder[0..-2].join('/') + '/'
			end
			@config = YAML.load_file description
		end
		def toc
			@config['toc']
		end
		def title
			@config['title']
		end
		def markdown_files
			@markdown_files ||= FileList.new self.toc.map{ |source| "#{@folder}/source/#{source}"}
		end
		def html_files
			@html_files ||= FileList.new self.toc.map{ |source| "#{@folder}/build/raw_html/#{source.ext('html')}"}
		end
	end
end