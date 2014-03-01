$parser.node.tour do |node|
	if node.code.include?("Android.app.notification.FLAG_HIGH_PRIORITY")
		$report.push node
	end
end