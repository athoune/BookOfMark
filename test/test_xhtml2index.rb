require "test/unit"
require '../lib/html2index'
require 'pp'

SAMPLE = "<body><h1>Book of mark</h1>
<h2>Install</h2>
<h3>MacOS</h3>
bla bla bla
<h3>Linux</h3>
bla bla bla
<h2>Usage</h2>
</body>"

class IndexTest < Test::Unit::TestCase
	def test_read
		idx = parse SAMPLE
		assert_equal [["h1", "Book of mark"],
		 ["h2", "Install"],
		 ["h3", "MacOS"],
		 ["h3", "Linux"],
		 ["h2", "Usage"]], idx.headers
	end
	def test_tree
		idx = parse SAMPLE
		assert_equal [[
			["h1", "Book of mark"],[
				["h2", "Install"], [
					["h3", "MacOS"], ["h3", "Linux"]
				],
				["h2", "Usage"]
			]
		]],  idx.tree
	end
end