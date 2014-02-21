# 
# NullPointerException과 상위 예외를 잡지 않는다
#

$parser.node.tour do |node|
	if node.type == NodeType::Catch 
		if node.arg.include?("NullPointerException") == true	
			$report.push node
		end
	end
end