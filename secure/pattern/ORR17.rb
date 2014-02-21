#
# 몸체가 비어있는 무한 루프를 사용하면 안 된다.
#

$parser.node.tour do |node|
	type = node.type
	if type == NodeType::For or type == NodeType::While
		if node.children.size == 0
			$report.push node
		end
	end
end