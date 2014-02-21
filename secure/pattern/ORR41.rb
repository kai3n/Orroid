#
# Information Leak of System Data
#

$parser.node.tour do |node|
	line = node.code
	if line.match("e.getMessage()") != nil or line.match("e.printStackTrace()") != nil
		$report.push node
	end
end