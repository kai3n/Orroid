$parser.node.tour do |node|
	if node.code.include?("PrivilegedAction") or node.code.include?("PrevilegedExceptionAction")
		$report.push node
	end
end