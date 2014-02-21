#
# Files under Global Access
#

$parser.node.tour do |node|
	if node.code.match("MODE_WORLD_READABLE") != nil
		$report.push node
	end
end