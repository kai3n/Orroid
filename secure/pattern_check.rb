def xml_check(path, &block)
	$err_list = Array.new
	$report = Array.new
	
	load path
	
	if block != nil and $err_list.size != 0
		$err_list.each do |err|
			block.call err
		end
	end
	
	if block != nil and $report.size != 0
		$report.each do |err|
			block.call err
		end
	end
end

def check(parser, path, &block)
	$parser = parser
	$err_list = Array.new
	$report = Array.new
	
	load path
	
	if block != nil and $err_list.size != 0
		$err_list.each do |err|
			block.call err
		end
	end

	if block != nil and $report.size != 0
		$report.each do |err|
			block.call err
		end
	end
end