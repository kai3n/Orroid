#
# Use of Insufficiently Random Values
#

$parser.doc_splited.each do |line|
	if line.code.match("Math.random") != nil
		node = NodeT.new
		node.code = line.code
		node.line_number = line.line

		$err_list.push node
	end
end