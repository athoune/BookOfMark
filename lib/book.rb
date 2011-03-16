require 'rubygems'
require 'yaml'
require 'maruku'

require 'html2index'

module BookOfMark
	class Book
		def initialize description
			@md = nil
			@path = description
			folder = description.split('/')
			if folder.length == 1
				@folder = nil
			else
				@folder = folder[0..-2].join('/') + '/'
			end
			@config = YAML.load_file description
		end
		def sources
			buffer = ""
			@config['toc'].each do |source|
				buffer += IO.read(@folder + source) + "\n"
			end
			@md = Maruku.new(buffer)
			buffer
		end
		def md
			self.sources if @md == nil
			@md
		end
		def to_html
			self.md.to_html
		end
		def to_latex
			self.md.to_latex
		end
		def to_toc
			#self.md.toc
			Html2index.parse(self.to_html).tree
		end
	end
end