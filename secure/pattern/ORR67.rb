$parser.node.tour do |node|
	if node.code.include?("createInsecureRfcommSocketToServiceRecord")
		$report.push node
	end
end