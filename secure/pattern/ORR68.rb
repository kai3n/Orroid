$parser.node.tour do |node|
	if node.code.include?("SecureRandom") and node.code.include?("byte[]")
		$report.push node
	elsif node.code.include?("setSeed")
		$report.push node
	end
end