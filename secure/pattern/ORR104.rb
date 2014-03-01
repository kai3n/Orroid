$parser.node.tour do |node|
	if node.code.match(/LISTEN_SIGNAL_STRENGTH[^s]/)
		$report.push node
	end
end