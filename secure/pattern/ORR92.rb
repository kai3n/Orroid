$parser.node.tour do |node|
	if node.code.include?("onChildViewAdded") or node.code.include?("onChildViewRemoved")
		$report.push node
	end
end