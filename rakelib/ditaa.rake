namespace :book do
	namespace :ditaa do
		task :convert => 'build/medias' do
			Dir.chdir 'source/' do
				FileList.new('**/*.ditaa').each do |ditaa|
					target = "../build/medias/" + ditaa.ext('png')
					create ditaa => target do
						sh "ditaa -s 2 #{ditaa} #{target}"
					end
				end
			end
		end
	end
	task :medias => 'ditaa:convert'
	
end