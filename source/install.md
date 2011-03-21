{:shell:    lang=sh code_background_color='#efefff'}
# Install

## Ruby

Book of Mark used Ruby, but you don't have to worry about, for most of tasks,
you just have to write *markdown* files and one *YAML*

### Rake

Rake can be installed with a package

	sudo apt-get install rake
{:shell}

or with a gem

	sudo gem install rake
{:shell}

You need a *Rakefile* (even an empty one)

	touch Rakefile
{:shell}

### Gems
You need some ruby gems

	sudo gem install maruku
	sudo gem install nokogiri
{:shell}