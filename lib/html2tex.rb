require 'nokogiri'

@tags = {}

#
def tag name, latex
	@tags[name] = LatexTag.new(name, "\\#{latex}{", '}')
end

#\begin \end
def tagblock name, latex
	@tags[name] = LatexTag.new(name , "\\begin{#{latex}}", "\\end{#{latex}}")
end

#just a mark
def tagmark name, latex
	@tags[name] = LatexTag.new(name, "\\{#{latex}}")
end

class LatexTag
	def initialize name, start=nil, stop=nil
		@name = name
		@start = start
		@stop = stop
	end
end

class XHTML2TEX < Nokogiri::XML::SAX::Document
	def start_element name, attributes = []
		puts "found a #{name}"
	end
	def characters string
	end
	def end_element name
	end
end

#parser = Nokogiri::HTML::SAX::Parser.new(XHTML2TEX.new)
#parser.parse(File.read(ARGV[0], 'rb'))