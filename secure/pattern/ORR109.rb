$parser.node.tour do |node|
	if node.code.include?("System.ALWAYS_FINISH_ACTIVITIES")
		$report.push node
	end
end