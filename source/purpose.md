#Book of Mark

Book of Mark is a tool to build documentation from markdown files.

Your book is described with a *YAML* file, templates are good old *erb* files,
and html is filtered with *css* pattern. The build is done with *rake*.
This is the classical MVC patterns.

![Mark the Evangelist](Mark_the_Evangelist.png "Engraving of Mark the Evangelist")

## Why

Why don't use Word, OpenOffice, Google Docs or Indesign?
Book of Mark use plain text files, so it's easy to share and versioned.
It's write once, publish everywhere. It use template.
It's git proof, and even subversion proof.

You can use it as is, with only a *.book* file, you can customize template, and,
last level you can use it as a toolbox and building your own rake file and specific workflow.

## The big picture

![Book of Mark Workflow](html.png)

## Technology

### YAML

[YAML](http://yaml.org/) is text format for structuring informations, half wiki, half json.
Your book is a **.book** file

### Markdown

[Markdown](http://daringfireball.net/projects/markdown/syntax) is a simple wiki like syntax for writing things.
It was created for the website [Daring Fireball](http://daringfireball.net/).
The source code is clean and human readable.

### ERB

[ERB](http://www.ruby-doc.org/stdlib/libdoc/erb/rdoc/) is the default template format for ruby.
It's hugly, but it's simple, and standard.

### CSS

Maruku provides naked HTML conversion. You can beautify it with CSS pattern, with the help of Nokogiri.

### Rake

[Rake](http://rake.rubyforge.org/) is ruby build tool. You can use it without knowing ruby.
With such tool, you only build what you need.
If you change one markdown file, you will rebuild just one LaTeX before viewing your new PDF.