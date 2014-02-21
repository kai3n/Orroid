#
# 스레드 안전한 메서드를 스레드 안전하지 않은 메서드로 오버라이드하지 않는다.
#

$parser.node_list[0].children.each do |node|
	if node.type == NodeType::DefClass
		
		# 상속받은 클래스이고, 부모 클래스가 테이블에 있는지 검사
		if node.extends != nil and $analyzer.structure[ node.extends ] != nil
			
			_super = $analyzer.structure[ node.extends ]

			node.children.each do |node|
				if node.type == NodeType::DefFunction
					
					# 해당 메소드가 상위 클래스에도 있는지 검사
					_super.mtd.each do |sm|
						if sm.name == node.name
							if sm.attrs.include?("synchronized") and !node.attrs.include?("synchronized")
								$report.push node
							end
						end
					end
				end
			end
		end
	end
end