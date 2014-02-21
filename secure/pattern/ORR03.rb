#
# finally 문을 갑작스럽게 빠져나와서는 안 된다.
#


$parser.node.tour do |node|
	if node.type == NodeType::Finally
		node.tour do |node|
			if node.type == NodeType::Return
				$report.push node
			end
		end
	end
end