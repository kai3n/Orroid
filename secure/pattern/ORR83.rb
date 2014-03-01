$parser.node.tour do |node|
	if node.code.include?("canZoomin") or node.code.include?("canZoomout") or node.code.include?("getScale")
		$report.push node
	end
end