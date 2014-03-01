$parser.node.tour do |node|
	if node.type == NodeType::Import
		if node.package == "Android.provider.Contacts"
			$report.push node
		end
	end
end