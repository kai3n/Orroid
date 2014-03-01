$parser.node.tour do |node|
	if node.code.include?("System.AIRPLANE_MODE_ON")
		$report.push node
	end
end