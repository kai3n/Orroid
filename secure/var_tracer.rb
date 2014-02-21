class VarTracer
	def initialize(parser)
		@parser = parser
		@operator = ["+", "-", "*", "/"]
	end

	def trace(value, start_node)
		result = Array.new
		node = start_node.prev

		if node != nil
			while true
				if node.type == NodeType::Operation and node.a == value
					slices = slice(node.b)

					slices.each do |slice|
						slice = slice.match(/\s*(?<a>[^\s]*)\s*/)[:a]

						if !is_const_string(slice) and !is_const_number(slice)
							data = slice.match(/((?<a>[a-zA-Z0-9_]*)\.)?(?<b>[a-zA-Z0-9_]+)\((?<c>.*)\)/)

							if data != nil
								jmp_to = nil
								class_name = data[:a]
								method = data[:b]
								param = data[:c]

								if class_name == nil
									$analyzer.structure[node.class_name].mtd.each do |sm|
										if sm.name == method
											jmp_to = sm.node
										end
									end
								else
									valid = false

									if $analyzer.structure[class_name] != nil
										valid = true
									else
										class_name = type_of(class_name, node)

										if class_name != nil
											if $analyzer.structure[class_name] != nil
												valid = true
											end
										end
									end

									if valid == true
										$analyzer.structure[class_name].mtd.each do |sm|
											if sm.name == method
												jmp_to = sm.node
											end
										end
									end
								end

								if jmp_to != nil
									if jmp_to.children.size > 0
										last_node = jmp_to.children.last

										if last_node.type == NodeType::Return
											slices = slice(last_node.value)

											slices.each do |slice|
												if !is_const_number(slice) and !is_const_string(slice)
													at = VarTracer.new(@parser)
													result += at.trace(slice, last_node)
												end
											end
										end

										next
									end
								end
							else
								at = VarTracer.new(@parser)
								result += at.trace(slice, node)
							end
						end
					end

					result.push node
				end

				if node.prev == nil
					node = node.parent

					if node == nil
						return result
					end

					if node.type == NodeType::DefFunction
						param = node.args
						break
					end
				else
					node = node.prev
				end
			end
		else
			node = start_node.parent
			at = VarTracer.new(@parser)
			result += at.trace(value, node)

			return result
		end

		return result
	end

	def is_const_string(str)
		return str.match(/".*"/) != nil
	end

	def is_const_number(str)
		return str.match(/^[0-9]+(f|U|L)?/) != nil
	end

	def slice(str)
		slices = Array.new
		in_string = false
		last = 0

		for i in 0..str.length-1
			if str[i] == "\""
				in_string ^= true
			end

			if @operator.member?(str[i]) and in_string == false
				slices.push str.slice(last, i)
				last = i+1
			end
		end

		slices.push str.slice(last, str.length)

		return slices
	end

	def type_of(name, start_node)
		node = start_node
		param = 0
		found = nil

		while true
			if node.type == NodeType::DefValue
				if node.name == name
					found = node.value_type
					break
				end
			end

			if node.prev == nil
				node = node.parent

				if node.type == NodeType::DefFunction
					param = node.args
					break
				end
			else
				node = node.prev
			end
		end

		if found == nil and param != 0
			param.split(",").each do |token|
				data = token.match(/(?<type>.+)\s+(?<name>.+)/)
				if data[:name] == name
					found = data[:type]
					break
				end
			end
		end

		if found == nil
			v = nil

			$analyzer.values[node.class_name].each do |nds|
				if nds.name == name
					v = nds
					break
				end
			end

			if v != nil
				found = v.value_type
			end
		end

		return found
	end
end