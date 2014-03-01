name = nil

$parser.node.tour do |node|
	if node.type == NodeType::DefValue
		if node.value_type == "Camera"
			name = node.name.split(";")[0]
		end
	end
	
	if name != nil
		if node.code.include?(name + ".release()")
			$report.push node
		end
	end
end