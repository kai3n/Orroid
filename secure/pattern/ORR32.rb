#
# Object Model Violation: Just one of equals() and hashCode() Defined
#

$parser.node.children.each do |node|
	if node.type == NodeType::DefClass
		methods = Array.new
		node.children.each do |node|
			methods.push node.name
		end

		if methods.member?("equals") or methods.member?("hashCode")
			$err_list.push node
		end
	end
end

