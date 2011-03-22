require 'pp'

module MaRuKu
	module Out
		module Latex
			Medias = Set.new
			def to_latex_im_image
				# pp self.url
				# pp self.title
				Medias << self.url
				"\\includegraphics[width=10cm]{#{self.url}}"
			end
			BookTexHeaders = {
				1=>'chapter',
				2=>'section',
				3=>'subsection',
				4=>'subsubsection',
				5=>'subsubsection'}

			def to_latex_header
				h = BookTexHeaders[self.level] || 'paragraph'
				title = children_to_latex
				%{\\%s{%s}\n\n} % [ h, title]
			end
			
		end
	end
end
