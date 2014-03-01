$parser.node.tour do |node|
	if node.code.include?("showFindDialog")
		$report.push node
	end
end