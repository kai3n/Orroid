$parser.node.tour do |node|
	if node.code.include?("System.AIRPLANE_MODE_RADIOS")
		$report.push node
	end
end