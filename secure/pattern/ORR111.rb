$parser.node.tour do |node|
	if node.code.include?("System.ANIMATOR_DURATION_SCALE")
		$report.push node
	end
end