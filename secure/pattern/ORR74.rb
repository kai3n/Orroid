$parser.node.tour do |node|
	if node.type == NodeType::DefValue
		if node.value_type == "Intent" and node.init_value.include?("new Intent")
			$report.push node
		end
	end
end