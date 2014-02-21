#
# 폐지되었거나 폐지될 예정인 class나 method사용하지 않기
#

not_allowed = [
"java.util.Date",
"java.util.Dictionary",
"java.lang.ThreadGroup"
]

$parser.node.filter( NodeType::Import ) do |node|
	
	if not_allowed.member?( node.package ) == true
		$report.push node
	end

end