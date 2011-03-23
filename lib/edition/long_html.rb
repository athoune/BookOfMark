class Long_HTML < Book::HTMLEdition
	attr :book_template
	def initialize book
		super book
		@book_template = 'lib/template/one_html.rhtml'
	end
	def filter_html dom
		6.times do |i|
			dom.css("h#{i}").each do |h|
				h.before "<a name=#{h.text}></a>"
			end
		end
	end
end