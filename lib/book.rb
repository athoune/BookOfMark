require 'rubygems'
require 'yaml'
require 'rake'

module BookOfMark
	class Book
		attr :folder
		attr :path
		#read a .book description
		def initialize description
			@md = nil
			@path = description
			folder = description.split('/')
			if folder.length == 1
				@folder = '.'
			else
				@folder = folder[0..-2].join('/') + '/'
			end
			@config = YAML.load_file description
		end
		def toc
			@config['toc']
		end
		def title
			@config['title']
		end
		def author
			@config['author']
		end
		def markdown_files
			@markdown_files ||= FileList.new self.toc.map{ |source| "#{@folder}/source/#{source}"}
		end
		def html_files
			@html_files ||= FileList.new self.toc.map{ |source| "#{@folder}/build/raw_html/#{source.ext('html')}"}
		end
		def getBinding
			return binding()
		end
	end
	def book
		@book ||= BookOfMark::Book.new FileList.new('*.book')[0]
	end
	def create st
		source = st.keys[0]
		target = st[source]
		mtime = (source.class == FileList) ? source.lastModification : File.mtime(source)
		yield self if not(File.file? target) or mtime > File.mtime(target)
	end
	# Convert markdown to html and filter it
	def md2html
		book.toc.each do |source|
			target = 'build/raw_html/' + source.ext('html')
			create "source/#{source}" => target do
				info "converting #{source} => #{target}"
				m = Maruku.new IO.read("source/#{source}")
				File.open(target, 'w') do |f|
					if block_given?
						html = m.to_filtered_html do |doc|
							yield doc
						end
					else
						html = m.to_html
					end
					f.write html
				end
			end
		end
	end
	
	def template template, data, result
		File.open(result, 'w') do |f|
			f.write ERB.new(IO.read template).result(data)
		end
	end
	
end