$parser.node.tour do |node|
	if node.code.include?("getInsecure")
		$report.push node
	end
end