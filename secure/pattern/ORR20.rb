# 주어진 객체의 class 형을 비교할 때 결코 클래스 명으로 비교해서는 안 된다.

$parser.node.tour do |node|
	if node.code.include?(".getClass().getName().equals(")
		$report.push node
	end
end