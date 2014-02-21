# 데이터 멤버는 private로 선언하고 접근 method를 따로 제공한다.

$parser.node.children.each do |node|
	if node.type == NodeType::DefClass

		node.children.each do |node|

			if node.type == NodeType::DefValue
				if node.accessor == "public"
					$report.push node
				end
			end
		end
	end
end