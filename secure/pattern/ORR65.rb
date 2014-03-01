$parser.node.tour do |node|
	if node.code.include?("listenUsingInsecureRfcommWithServiceRecord")
		$report.push node
	end
end