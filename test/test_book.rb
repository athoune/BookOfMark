require "test/unit"
require '../lib/book'
require 'pp'

class BookTest < Test::Unit::TestCase
	def testRead
		b = BookOfMark::Book.new '../book_of_mark.book'
		pp b.to_html
		p ""
		pp b.to_latex
		p ""
		pp b.to_toc
	end
end