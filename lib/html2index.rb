require 'rubygems'
require 'nokogiri'

class Tree
	attr :tree
	def initialize
		@tree = []
		@stairs = []
	end
	def feed tags
		f = tags.shift
		@tree = [ [f] ]
		@stairs = [f[0]]
		@current = @tree[0]
		tags.each do |t|
			self.tag t
		end
	end
	def tag tag
		if tag[0] == @stairs[-1]
			@current << tag
		else
			if tag[0] > @stairs[-1]
				@stairs << tag[0]
				@current << [tag]
				@current = @current[-1]
			else
				while @stairs[-1] > tag[0]
					@stairs.pop
					@current = @tree[-1][-1]
				end
				self.tag tag
			end
		end
	end
end

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
			@headers << [name, @buffer]
		end
	end
	def tree
		t = Tree.new
		t.feed @headers
		t.tree
	# 	hh = @headers
	# 	before = hh.shift
	# 	t = [[before]]
	# 	current = t[0]
	# 	stairs = [before[0]]
	# 	hh.each do |h|
	# 		if h[0] == stairs[-1]
	# 			current << h
	# 		else
	# 			if h[0] > stairs[-1]
	# 				stairs << h[0]
	# 				current << [h]
	# 				current = current[-1]
	# 			else
	# 				stairs.pop
	# 			end
	# 		end
	# 		pp stairs
	# 	end
	# 	t
	end
end

def parse xhtml
	x = XHTML2Index.new
	parser = Nokogiri::HTML::SAX::Parser.new x
	parser.parse xhtml
	x
end 