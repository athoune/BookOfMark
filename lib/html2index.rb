require 'rubygems'
require 'nokogiri'

class XHTML2Index < Nokogiri::XML::SAX::Document
	attr :headers
	def initialize
		@tags = %w{h1 h2 h3 h4 h5 h6}
		@headers = []
		@buffer = ""
	end
	def start_element name, attributes = []
		if @tags.include? name
			@buffer = ""
		end
	end
	def characters string
		@buffer += string
	end
	def end_element name
		if @tags.include? name
			@headers << {name => @buffer}
		end
	end
	def tree
		t = []
		hh = @headers
		before = hh.pop
		hh.each do |h|
			pp h
		end
	end
end

def parse xhtml
	x = XHTML2Index.new
	parser = Nokogiri::HTML::SAX::Parser.new x
	parser.parse xhtml
	x
end 