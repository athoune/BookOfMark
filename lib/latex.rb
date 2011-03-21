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
			TexHeaders = {
				1=>'section',
				2=>'subsection',
				3=>'subsubsection',
				4=>'paragraph'}

			def to_latex_header
				h = TexHeaders[self.level] || 'paragraph'
				title = children_to_latex
				%{\\%s{%s}\n\n} % [ h, title]
			end
			
		end
	end
end
