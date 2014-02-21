input_table = ["getText().toString", "nextLine", "readLine"]
secure_table = ["replace", "replaceAll", "replaceFirst"]

class Info
	attr_accessor :class_name, :method_name, :line, :code, :flag

	def initialize
		@class_name = ""
		@method_name = ""
		@line = ""
		@code = ""
		@flag = false
	end

	def set(node)
		@class_name = node.class_name
		@method_name = node.method_name
		@line = node.line_number
		@code = node.code
	end

	def setflag
		@flag = true
	end
end

class InfoStack
	attr_accessor :stack

	def initialize
		@stack = Array.new
	end

	def push(info)
		@stack.push info
	end
end

$parser.node.tour do |node|

	if node.type == NodeType::DefValue and node.value_type == "File"
		data = node.code.match(/^File\s*(?<v>[a-zA-Z0-9_]+)\s*=\s*new\s+File\((?<p>.*)\);/)

		if data != nil
			traced = nil
			is = InfoStack.new
			i = Info.new
			i.set(node)
			is.push(i)
			param = data[:p]
			tracer = VarTracer.new($parser)
			from_input = false
			replaced = false
			param.gsub!("\s", "")
			p = param.split("+")
			p.each do |param|
				if param.match(/".*"/) == nil
					traced = tracer.trace(param, node)

					traced.each do |node|
						if node.type == NodeType::Operation
							if node.code.include?("replacedAll")
								replaced = true
								i = Info.new
								i.set(node)
								i.setflag
								is.push(i)
							end

							if node.code.include?("replacedFirst")
								replaced = true
								i = Info.new
								i.set(node)
								i.setflag
								is.push(i)
							end

							if node.code.include?("getInput")
								from_input = true
								i = Info.new
								i.set(node)
								i.setflag
								is.push(i)
							end

							if node.code.include?("getText().toString")
								from_input = true
								i = Info.new
								i.set(node)
								i.setflag
								is.push(i)
							end

							if node.code.include?("nextLine")
								from_input = true
								i = Info.new
								i.set(node)
								i.setflag
								is.push(i)
							end

							if node.code.include?("readLine")
								from_input = true
								i = Info.new
								i.set(node)
								i.setflag
								is.push(i)
							end
						else
							i = Info.new
							i.set(node)
							is.push(i)
						end
					end
				end
			end

			if from_input and !replaced
				node.info_stack = is
				$report.push node
			end
		end
	end

	if node.type == NodeType::DefValue and node.value_type == "FileOutputStream"
		data = node.code.match(/^FileOutputStream\s*(?<v>[a-zA-Z0-9_]+)\s*=\s*new\s+FileOutputStream\((?<p>.*)\);/)

		if data != nil
			traced = nil
			is = InfoStack.new
			i = Info.new
			i.set(node)
			is.push(i)
			param = data[:p]
			tracer = VarTracer.new($parser)
			from_input = false
			replaced = false
			param.gsub!("\s", "")
			p = param.split("+")

			p.each do |param|
				if param.match(/".*"/) == nil
					traced = tracer.trace(param, node)

					traced.each do |node|
						if node.type == NodeType::Operation
							if node.code.include?("replacedAll")
								replaced = true
								i = Info.new
								i.set(node)
								i.setflag
								is.push(i)
							end

							if node.code.include?("replacedFirst")
								replaced = true
								i = Info.new
								i.set(node)
								i.setflag
								is.push(i)
							end

							if node.code.include?("getInput")
								from_input = true
								i = Info.new
								i.set(node)
								i.setflag
								is.push(i)
							end

							if node.code.include?("getText().toString")
								from_input = true
								i = Info.new
								i.set(node)
								i.setflag
								is.push(i)
							end

							if node.code.include?("nextLine")
								from_input = true
								i = Info.new
								i.set(node)
								i.setflag
								is.push(i)
							end

							if node.code.include?("readLine")
								from_input = true
								i = Info.new
								i.set(node)
								i.setflag
								is.push(i)
							end
						else
							i = Info.new
							i.set(node)
							is.push(i)
						end
					end
				end
			end

			if from_input and !replaced
				node.info_stack = is
				$report.push node
			end
		end
	end

	if node.type == NodeType::DefValue and node.value_type == "FileInputStream"
		data = node.code.match(/^FileInputStream\s*(?<v>[a-zA-Z0-9_]+)\s*=\s*new\s+FileInputStream\((?<p>.*)\);/)

		if data != nil
			traced = nil
			is = InfoStack.new
			i = Info.new
			i.set(node)
			is.push(i)
			param = data[:p]
			tracer = VarTracer.new($parser)
			from_input = false
			replaced = false
			param.gsub!("\s","")
			p = param.split("+")

			p.each do |param|
				if param.match(/".*"/) == nil
					traced = tracer.trace(param, node)

					traced.each do |node|
						if node.type == NodeType::Operation
							if node.code.include?("replacedAll")
								replaced = true
								i = Info.new
								i.set(node)
								i.setflag
								is.push(i)
							end

							if node.code.include?("replacedFirst")
								replaced = true
								i = Info.new
								i.set(node)
								i.setflag
								is.push(i)
							end

							if node.code.include?("getInput")
								from_input = true
								i = Info.new
								i.set(node)
								i.setflag
								is.push(i)
							end

							if node.code.include?("getText().toString")
								from_input = true
								i = Info.new
								i.set(node)
								i.setflag
								is.push(i)
							end

							if node.code.include?("nextLine")
								from_input = true
								i = Info.new
								i.set(node)
								i.setflag
								is.push(i)
							end

							if node.code.include?("readLine")
								from_input = true
								i = Info.new
								i.set(node)
								i.setflag
								is.push(i)
							end
						else
							i = Info.new
							i.set(node)
							is.push(i)
						end
					end
				end
			end

			if from_input and !replaced
				node.info_stack = is
				$report.push node
			end
		end
	end

	if node.type == NodeType::DefValue and node.value_type == "FileWriter"
		data = node.code.match(/^FileWriter\s*(?<v>[a-zA-Z0-9_]+)\s*=\s*new\s+FileWriter\((?<p>.*)\);/)

		if data != nil
			traced = nil
			is = InfoStack.new
			i = Info.new
			i.set(node)
			is.push(i)
			param = data[:p]
			tracer = VarTracer.new($parser)
			from_input = false
			replaced = false
			param.gsub!("\s","")
			p = param.split("+")

			p.each do |param|
				if param.match(/".*"/) == nil
					traced = tracer.trace(param, node)

					traced.each do |node|
						if node.type == NodeType::Operation
							if node.code.include?("replacedAll")
								replaced = true
								i = Info.new
								i.set(node)
								i.setflag
								is.push(i)
							end

							if node.code.include?("replacedFirst")
								replaced = true
								i = Info.new
								i.set(node)
								i.setflag
								is.push(i)
							end

							if node.code.include?("getInput")
								from_input = true
								i = Info.new
								i.set(node)
								i.setflag
								is.push(i)
							end

							if node.code.include?("getText().toString")
								from_input = true
								i = Info.new
								i.set(node)
								i.setflag
								is.push(i)
							end

							if node.code.include?("nextLine")
								from_input = true
								i = Info.new
								i.set(node)
								i.setflag
								is.push(i)
							end

							if node.code.include?("readLine")
								from_input = true
								i = Info.new
								i.set(node)
								i.setflag
								is.push(i)
							end
						else
							i = Info.new
							i.set(node)
							is.push(i)
						end
					end
				end
			end

			if from_input and !replaced
				node.info_stack = is
				$report.push node
			end
		end
	end

	if node.type == NodeType::DefValue and node.value_type == "openFileOutput"
		data = node.code.match(/^openFileOutput\s*(?<v>[a-zA-Z0-9_]+)\s*=\s*new\s+openFileOutput\((?<p>.*)\);/)

		if data != nil
			traced = nil
			is = InfoStack.new
			i = Info.new
			i.set(node)
			is.push(i)
			param = data[:p]
			tracer = VarTracer.new($parser)
			from_input = false
			replaced = false
			param.gsub!("\s","")
			p = param.split("+")

			p.each do |param|
				if param.match(/".*"/) == nil
					traced = tracer.trace(param, node)

					traced.each do |node|
						if node.type == NodeType::Operation
							if node.code.include?("replacedAll")
								replaced = true
								i = Info.new
								i.set(node)
								i.setflag
								is.push(i)
							end

							if node.code.include?("replacedFirst")
								replaced = true
								i = Info.new
								i.set(node)
								i.setflag
								is.push(i)
							end

							if node.code.include?("getInput")
								from_input = true
								i = Info.new
								i.set(node)
								i.setflag
								is.push(i)
							end

							if node.code.include?("getText().toString")
								from_input = true
								i = Info.new
								i.set(node)
								i.setflag
								is.push(i)
							end

							if node.code.include?("nextLine")
								from_input = true
								i = Info.new
								i.set(node)
								i.setflag
								is.push(i)
							end

							if node.code.include?("readLine")
								from_input = true
								i = Info.new
								i.set(node)
								i.setflag
								is.push(i)
							end
						else
							i = Info.new
							i.set(node)
							is.push(i)
						end
					end
				end
			end

			if from_input and !replaced
				node.info_stack = is
				$report.push node
			end
		end
	end
end