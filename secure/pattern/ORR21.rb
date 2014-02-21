# public static field는 final로 선언해 주도록 한다.

$parser.node.children.each do |node|
	if node.type == NodeType::DefClass

		node.children.each do |node|
			if node.type == NodeType::DefValue
				if node.accessor == "public"
					if node.attrs != nil and node.attrs.include?("static") and node.attrs.include?("field")
						$report.push node
					end
				end
			end
		end
	end
end