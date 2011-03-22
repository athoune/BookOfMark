module Book
	class Edition
		attr_accessor :book
		def initialize book
			@book = book
		end
		def pages
			raise StandardError 'not implemented'
		end
		def assembly
			raise StandardError 'not implemented'
		end
	end

	class HTMLEdition < Edition
		def pages
			p = []
			@book.toc.each do |source|
				target = 'build/raw_html/' + source.ext('html')
				p << target
				create "source/#{source}" => target do
					info "converting #{source} => #{target}"
					m = Maruku.new IO.read("source/#{source}")
					File.open(target, 'w') do |f|
						f.write m.to_html
					end
				end
			end
			p
		end
		def index
			buffer = ''
			FileList['build/raw_html/**.html'].each do |file|
				buffer += IO.read(file) + "\n"
			end
			Html2index.parse buffer
		end
	end

	class LaTeXEdition < Edition
		def pages
			p = []
			@book.toc.each do |source|
				target = 'build/raw_latex/' + source.ext('tex')
				p << target
				create "source/#{source}" => target do
					info "converting #{source} => #{target}"
					m = Maruku.new IO.read("source/#{source}")
					File.open(target, 'w') do |f|
						f.write m.to_latex
					end
				end
			end
			p
		end
	end
end