#
# NaN과 값을 비교하지 않는다
#

$parser.node.tour do |node|
	if node.type == NodeType::If
		if node.expression.include?("Double.NaN") == true
			$report.push node
		end
	end
end