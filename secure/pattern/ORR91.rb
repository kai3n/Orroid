$parser.node.tour do |node|
	if node.code.include?("capturePicture")
		$report.push node
	end
end