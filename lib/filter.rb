require 'rubygems'
require 'nokogiri'

class Maruku
	def to_filtered_html
		doc = Nokogiri::HTML::DocumentFragment.parse self.to_html
		yield doc
		doc.to_html
	end
end