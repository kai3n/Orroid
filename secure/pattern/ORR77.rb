$parser.node.tour do |node|
	if node.code.include?("clearView")
		$report.push node
	end
end