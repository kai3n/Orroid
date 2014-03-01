$parser.node.tour do |node|
	if node.type == NodeType::DefValue
		if node.value_type == "KeyguardManager.KeyguardLock"
			$report.push node
		end
	end
end