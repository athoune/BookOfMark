require 'pp'
module Rake
	class FileList
		def lastModification
			last = nil
			self.each do |f|
				m = File::mtime f
				last = m if last == nil or m > last
			end
			last
		end
	end
end 