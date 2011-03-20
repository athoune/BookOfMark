require 'pp'

module MaRuKu
	module Out
		module Latex
			Medias = Set.new
			def to_latex_im_image
				# pp self.url
				# pp self.title
				Medias << self.url
				"\\includegraphics{#{self.url}}"
			end
		end
	end
end