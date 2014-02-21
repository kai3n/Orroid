#
# Thread.run()메서드를 호출하지 않는다.
#

$parser.node.tour do |node|
	if node.code.match(/Thread\(.*\)\.run\(\)/) != nil
		$report.push node
	end
end