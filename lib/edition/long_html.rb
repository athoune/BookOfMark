class Long_HTML < Book::HTMLEdition
	def filter_html dom
		6.times do |i|
			dom.css("h#{i}").each do |h|
				h.before "<a name=#{h.text}></a>"
			end
		end
	end
end