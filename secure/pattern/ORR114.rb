$parser.node.tour do |node|
	if node.code.include?("System.BLUETOOTH_ON")
		$report.push node
	end
end