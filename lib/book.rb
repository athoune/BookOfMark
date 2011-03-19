require 'rubygems'
require 'yaml'
require 'rake'
require 'maruku'

require 'html2index'

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
			FileList.new self.toc.map{ |source| "#{@folder}/source/#{source}"}
		end
		def html_files
			FileList.new self.toc.map{ |source| "#{@folder}/build/raw_html/#{source.ext('html')}"}
		end
		#concatened markdown source
		def sources
			buffer = ""
			@config['toc'].each do |source|
				buffer += IO.read(@folder + source) + "\n"
			end
			@md = Maruku.new(buffer)
			buffer
		end
		#lazy markdown instance
		def md
			self.sources if @md == nil
			@md
		end
		#one big html
		def to_html
			self.md.to_html
		end
		def to_html_splitted header=1
			pages = []
			#[FIXME] bug when book doesn't start with a h1
			#[FIXME] split also on n-1
			self.to_html.split("<h#{header} ").each do |page|
				pages << "<h#{header} #{page}" if page.strip != ""
			end
			pages
		end
		#one big latex
		def to_latex
			self.md.to_latex
		end
		#table of content
		def to_toc
			#self.md.toc
			Html2index.parse(self.to_html).tree
		end
	end
end