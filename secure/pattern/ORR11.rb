#
# 락을 활성화한 후 블럭될 수 있는 연산을 수행하지 않는다
#

$parser.node.filter( NodeType::DefClass ) do |node|
	
	node.filter( NodeType::DefFunction ) do |node|
		if node.attrs.include?("synchronized") == true
			
			node.tour do |node|
				if node.type == NodeType::CallFunc
					if node.a == "Thread" and node.b == "sleep"
						$report.push node
					end
				end
			end

		end
	end

end