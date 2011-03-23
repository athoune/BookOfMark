namespace :book do
	namespace :html do
		directory 'build/raw_html'
		directory 'build/one_html'

		task :raw_html => 'build/raw_html' do
			md2html do |doc|
				6.times do |i|
					doc.css("h#{i}").each do |h|
						h.before "<a name=#{h.text}></a>"
					end
				end
			end
		end
		task :filter => :raw_html
		task :index => :filter do
			IDX = "build/raw_html/index.json"
			create book.html_files => IDX do
				info "new index"
				buffer = ''
				book.html_files.each{ |html| buffer += IO.read(html) + "\n"}
				File.open(IDX, 'w') do |f|
					f.write Html2index.parse(buffer).tree.to_json
				end
			end
		end
		task :one_html => [:index, 'build/one_html', '^medias'] do
			cp FileList['build/medias/*'], 'build/one_html/'
			create 'build/raw_html/index.json' => 'build/one_html/index.html' do
				template 'lib/template/one_html.rhtml', book.getBinding, 'build/one_html/index.html'
			end
		end
	end
end