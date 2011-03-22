namespace :book do
	namespace :latex do
		directory 'build/raw_latex'

		task :raw_latex => ['build/raw_latex', 'build/medias'] do
			book.toc.each do |source|
				target = 'build/raw_latex/' + source.ext('tex')
				create "source/#{source}" => target do
					info "converting #{source} => #{target}"
					m = Maruku.new IO.read("source/#{source}")
					File.open(target, 'w') do |f|
						f.write m.to_latex
					end
				end
			end
			MaRuKu::Out::Latex::Medias.each do |media|
				if File.exist? "source/#{media}"
					create "source/#{media}" => "build/medias/#{media}" do
						cp "source/#{media}", "build/medias/#{media}"
					end
				end
			end
		end
		task :latex => :raw_latex do
			create book.path => 'build/raw_latex/__index.tex' do
				template 'lib/template/book.tex.rhtml', book.getBinding, 'build/raw_latex/__index.tex'
			end
		end
		task :pdf => [:latex, '^medias'] do
			cp FileList['build/medias/*'], 'build/raw_latex/'
			create FileList.new('build/raw_latex/*.tex') => 'build/raw_latex/__index.pdf' do
				Dir.chdir 'build/raw_latex' do
					2.times do
						sh 'pdflatex __index.tex'
					end
				end
			end
		end
	end
	desc "Build pdf"
	task :pdf => 'latex:pdf'
	
	namespace :pdf do
		task :open => '^pdf' do
			sh "open build/raw_latex/__index.pdf"
		end
	end

end