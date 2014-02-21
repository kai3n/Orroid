#
# Detection of Error Condition Without Action
#

$parser.node.tour do |node|
	if node.type == NodeType::Catch
		if node.children.size == 0
			$err_list.push node
		end
	end
end
