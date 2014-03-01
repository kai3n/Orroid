name = nil

$parser.node.tour do |node|
	if node.type == NodeType::DefValue
		if node.value_type == "Carmera"
			name = node.name.split(";")[0]
		end
	end
	
	if name != nil
		if node.type == NodeType::Try
			node.tour do |n|
				if n.code.include?(name + ".open()")
					$report.push node
				end
			end
		end
	end
end