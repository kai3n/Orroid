$parser.node.tour do |node|
	if node.code.include?("freeMemory")
		$report.push node
	end
end