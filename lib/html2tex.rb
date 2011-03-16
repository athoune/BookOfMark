require 'rubygems'
require 'nokogiri'

module Html2tex
	@tags = {}

	#
	def Html2tex.tag name, latex
		@tags[name.id2name] = LatexTag.new(name, "\\#{latex}{", '}')
	end

	#\begin \end
	def Html2tex.begin_end_tag name, latex
		@tags[name.id2name] = LatexTag.new(name , "\\begin{#{latex}}", "\\end{#{latex}}")
	end

	#just a mark
	def Html2tex.empty_tag name, latex
		@tags[name.id2name] = LatexTag.new(name, "\\{#{latex}}")
	end

	class LatexTag
		attr_reader :start, :stop
		def initialize name, start=nil, stop=nil
			@name = name
			@start = start
			@stop = stop
		end
	end

	class XHTML2TEX < Nokogiri::XML::SAX::Document
		attr :buffer
		def initialize tags
			@tags = tags
			@buffer = ""
		end
		def start_element name, attributes = []
			if @tags.key? name
				@buffer += @tags[name].start
			end
		end
		def characters string
			@buffer += string
		end
		def end_element name
			if @tags.key? name
				@buffer += @tags[name].stop
			end
		end
	end

	def Html2tex.parse html
		buffer = ""
		x = XHTML2TEX.new @tags
		parser = Nokogiri::HTML::SAX::Parser.new x
		parser.parse html
		return x.buffer
	end
end
#parser = Nokogiri::HTML::SAX::Parser.new(XHTML2TEX.new)
#parser.parse(File.read(ARGV[0], 'rb'))