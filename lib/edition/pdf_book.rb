class PDF_book < Book::LaTeXEdition
	attr :format
	def initialize
		@format = 'a4'
	end
end