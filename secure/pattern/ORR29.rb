#
# 객체 생성 중 this 참조가 유출되지 않게한다
#

$parser.node.filter( NodeType::DefClass ) do |node|
	klass_name = node.name

	member_value = Hash.new

	# 멤버 변수 테이블을 만든다
	node.children.each do |node|
		if node.type == NodeType::DefValue
			member_value[node.name] = node
		end
	end

	# 생성자를 찾는다.
	node.children.each do |node|
		if node.type == NodeType::DefFunction

			# 생성자
			if node.name == klass_name
				
				# public static 멤버 변수에 this를 대입하는걸 찾음
				node.children.each do |node|
					if node.type != nil 
						if node.type == NodeType::Operation
							if member_value[node.a] != nil and node.b == "this" and member_value[node.a].attrs != nil
								if	member_value[node.a].attrs.include?("static") and
									member_value[node.a].accessor.include?("public")
										$report.push node
								end
							end
						end
					end
				end

				break
			end
	
		end
	end
end