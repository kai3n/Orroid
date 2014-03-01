$parser.node.tour do |node|
	if node.code.include?("System.AUTO_TIME[^_ZONE]")
		$report.push node
	end
end