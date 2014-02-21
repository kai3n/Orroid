#
# RuntimeException, Exception, Throwable 예외를 발생시키지 않는다.
#


$parser.node.tour do |node|
	if node.type == NodeType::Throw
		not_allowed = ["RuntimeException", "Exception", "Throwable"]
		
		not_allowed.each do |no|
			regex = /new\s+#{no}\s*\(.*\)/	

			if node.exception.match(regex) != nil
				$report.push node
			end
		end
	end
end