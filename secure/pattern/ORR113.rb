$parser.node.tour do |node|
	if node.code.include?("System.AUTO_TIME_ZONE")
		$report.push node
	end
end