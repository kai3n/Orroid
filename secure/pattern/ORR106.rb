$parser.node.tour do |node|
	if node.code.include?("System.ADB_ENABLED")
		$report.push node
	end
end