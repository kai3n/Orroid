$parser.node.tour do |node|
	if node.code.include?("Thread.suspend")
		$report.push node
	end
end