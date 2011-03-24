namespace :book do
	namespace :graphviz do
		task :convert => 'build/medias' do
			Dir.chdir 'source/' do
				FileList.new('**/*.dot').each do |dot|
					target = "../build/medias/" + dot.ext('png')
					create dot => target do
						sh "dot -Tpng -o#{target} #{dot}"
					end
				end
			end
		end
	end
	task :medias => 'graphviz:convert'
end