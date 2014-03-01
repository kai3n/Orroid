flag = false

$parser.node.tour do |node|
	if node.type == NodeType::Import and node.package == "com.google.android.gcm"
		flag = true
	end
	
	if flag and (node.code.include?("GCMBaseIntentService") or node.code.include?("GCMBroadcastReceiver") or node.code.include?("GCMConstants"))
		$report.push node
	end
end