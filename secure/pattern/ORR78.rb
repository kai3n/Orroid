$parser.node.tour do |node|
	if node.code.include?("findAll")
		$report.push node
	end
end