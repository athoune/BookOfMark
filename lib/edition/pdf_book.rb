class PDF_book < Book::LaTeXEdition
	attr :format, :book_template
	def initialize
		@format = 'a4'
		@book_template = 'lib/template/book.tex.rhtml'
	end
end