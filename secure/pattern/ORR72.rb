$parser.node.tour do |node|
	if node.code.include?("getHeight") or node.code.include?("getOrientation") or node.code.include?("getPixelFormat") or node.code.include?("getWidth")
		$report.push node
	end
end