#
# readObejct() 내에서 오버라이드될 수 있는 메서드를 호출하지 않는다.
#

# Serializable 이 구현된 클래스를 찾음
method = nil

$parser.node.children.each do |node|
	if node.type == NodeType::DefClass
		if node.implements != nil and node.implements.include?("Serializable") == true

			# readObject 메소드를 찾음
			node.children.each do |node|
				if node.type == NodeType::DefFunction
					if node.name == "readObject"

						# readObject내부에서 call 되는 메소드가 상속 가능한 메소드인지 검사
						node.children.each do |node|
							if node.type == NodeType::CallFunc
								$analyzer.structure[$parser.class_name].mtd.each do |sm|
									if sm.name == node.b
										method = sm.node
									end
								end

								if (method != nil) and ((method.accessor == "public") or (method.accessor == "protected"))
									$report.push node
								end
							end
						end

					end
				end
			end
		end

	end
end