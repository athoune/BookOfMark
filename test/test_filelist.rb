require "test/unit"
require 'rubygems'
require 'rake'
require '../lib/filelist'
require 'pp'

class FileListTest < Test::Unit::TestCase
	def testLast
		assert_equal Time, FileList.new("*.rb").lastModification.class
	end
end
