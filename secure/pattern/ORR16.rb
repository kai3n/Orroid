# 되도록이면 finalize() 메서드를 사용하지 않는다.

$parser.node.tour do |node|
	if node.code.include?("finalize()")
		$report.push node
	end
end