$parser.node.tour do |node|
	if node.code.include?("setCertificate")
		$report.push node
	end
end