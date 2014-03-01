$parser.node.tour do |node|
	if node.code.include?("System.ANDROID_ID")
		$report.push node
	end
end