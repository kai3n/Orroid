$parser.node.tour do |node|
	if node.code.include?("onGlobalFocusChanged")
		$report.push node
	end
end