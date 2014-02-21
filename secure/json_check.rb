require "json"
require "find"

def make_list(path, exp)
	list = Array.new
	Find.find( path ) do |path|
		if FileTest.directory?(path)
			if File.basename(path)[0] == ?.
			   Find.prune
			else
				next
			end
		else
			if path.match( exp ) != nil
				list.push path
			end
		end
	end

	return list
end

if $language == "E"
	json_list = make_list( "pattern_json_E", /.*\.json/ )
else
	json_list = make_list( "pattern_json_K", /.*\.json/ )
end

json_list.each do |json|
	fp = File.new(json, "r:utf-8")
	
	doc = fp.read()

	begin
	JSON.load(doc)
	rescue
		puts "ERR on #{json}"
	end

	fp.close
end