$parser.node.tour do |node|
	if node.code.include?("setJavaScriptEnabled")
		$report.push node
	end
end