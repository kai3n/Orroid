#JPNM : JParserNodeMaker
class JPNM
	def initialize
		@code = ""
		@n_list = Array.new
	end

	def rm_string(code)
		line = code
		ind_arr = Array.new
		quote = ""

		for i in 0..line.length-1
			if line[i] == "\""
				if quote == ""
					ind_arr.push i
					quote = "\""
				elsif quote == "\""
					ind_arr.push i
					quote = ""
				end
			end
			if line[i] == "\'"
				if quote == ""
					ind_arr.push i
					quote = "\'"
				elsif quote == "\'"
					ind_arr.push i
					quote = ""
				end
			end
		end

		result = ""
		part_arr = Array.new

		if ind_arr.length > 0
			for i in 0..(ind_arr.length/2)
				if i == 0
					part_arr.push line.slice(0, ind_arr[0])
				elsif i == ind_arr.length/2
					part_arr.push line.slice(ind_arr[2*i-1] + 1, code.length-ind_arr[2*i-1]-1)
				else
					part_arr.push line.slice(ind_arr[2*i-1] + 1, ind_arr[2*i] - ind_arr[2*i-1]-1)
				end
			end

			for i in 0..part_arr.length-1
				if i == 0
					result += part_arr[i]
				else
					result += "String" + part_arr[i]
				end
			end
		else
			result = line
		end

		return result
	end

	def making_node_1(code)
		@code = rm_string(code)

		if @code.match(JPConst::R_FUNCTION) != nil
			data = JPConst::R_FUNCTION.match(@code)
			node = DefFunctionNode.new
			node.name = data[:name]
			node.accessor = data[:accessor]
			node.attrs = data[:attr]
			node.return = data[:ret]
			node.args = data[:args]
			@n_list.push node
		elsif @code.match(JPConst::R_GLB_VAR_INIT) != nil
			data = JPConst::R_GLB_VAR_INIT.match(@code)
			c_list = Array.new
			in_bracket = false
			in_s_bracket = false
			val = data[:value]

			last = 0

			for i in 0..val.length-1
				if val[i] == "["
					in_s_bracket = true
				elsif val[i] == "]"
					in_s_bracket = false
				elsif val[i] == "("
					in_bracket = true
				elsif val[i] == ")"
					in_bracket = false
				elsif val[i] == "," and !in_s_bracket and !in_bracket
					c_list.push val.slice(last, i)
					last = i + 1
				end
			end

			c_list.push val.slice(last, val.length)

			for i in 0..c_list.length-1
				node = DefValueNode.new
				node.accessor = data[:accessor]
				node.attrs = data[:attr]
				node.value_type = data[:type]
				if i == 0
					node.name = data[:name]
					node.init_value = c_list[0]
					@n_list.push node
				end
			end
		elsif @code.match(JPConst::R_GLB_VAR) != nil
			data= JPConst::R_GLB_VAR.match(@code)
			c_list = data[:name].split(",")

			c_list.each do |name|
				node = DefValueNode.new
				node.accessor = data[:accessor]
				node.attrs = data[:attr]
				node.value_type = data[:type]
				node.name = name.ltrim("\s").rtrim("\s")
				@n_list.push node
			end
		end

		return @n_list
	end

	def making_node_2(code)
		@code = rm_string(code)

		if @code.match(JPConst::R_PACKAGE) != nil
			data = JPConst::R_PACKAGE.match(@code)
			node = PackageNode.new
			node.package = data[:package]
			@n_list.push node
		elsif @code.match(JPConst::R_IMPORT) != nil
			data = JPConst::R_IMPORT.match(@code)
			node = ImportNode.new
			node.package = data[:package]
			@n_list.push node
		elsif @code.match(JPConst::R_CLASS) != nil
			data = JPConst::R_CLASS.match(@code)
			node = DefClassNode.new
			node.name = data[:name]
			node.attrs = data[:attrs]
			node.extends = data[:extends]
			node.implements = data[:implements]
			@n_list.push node
		elsif @code.match(JPConst::R_IF) != nil
			data = JPConst::R_IF.match(@code)
			node = IfNode.new
			node.expression = data[:expr]
			@n_list.push node
		elsif @code.match(JPConst::R_ELSE) != nil
			node = ElseNode.new
			@n_list.push node
		elsif @code.match(JPConst::R_WHILE) != nil
			data = JPConst::R_WHILE.match(@code)
			node = LoopNode.new
			node.condition = data[:condition]
			@n_list.push node
		elsif @code.match(JPConst::R_FOR) != nil
			data = JPConst::R_FOR.match(@code)
			node = ForNode.new
			node.init = data[:a]
			node.condition = data[:b]
			node.afterthought = data[:c]
			@n_list.push node
		elsif @code.match(JPConst::R_TRY) != nil
			node = TryNode.new
			@n_list.push node
		elsif @code.match(JPConst::R_CATCH) != nil
			data = JPConst::R_CATCH.match(@code)
			node = CatchNode.new
			node.arg = data[:arg]
			@n_list.push node
		elsif @code.match(JPConst::R_THROW) != nil
			data = JPConst::R_THROW.match(@code)
			node = ThrowNode.new
			node.exception = data[:exception]
			@n_list.push node
		elsif @code.match(JPConst::R_FINALLY) != nil
			node = FinallyNode.new
			@n_list.push node
		elsif @code.match(JPConst::R_CALLFUNC) != nil
			data = JPConst::R_CALLFUNC.match(@code)
			node = CallFuncNode.new
			node.a = data[:class]
			node.b = data[:method]
			node.param = data[:param]
			@n_list.push node
		elsif @code.match(JPConst::R_RETURN) != nil
			data = JPConst::R_RETURN.match(@code)
			node = ReturnNode.new
			node.value = data[:value]
			@n_list.push node
		elsif @code.match(JPConst::R_OP) != nil
			data = JPConst::R_OP.match(@code)
			node = OperationNode.new
			node.a = data[:a]
			node.b = data[:b]
			node.op = data[:op]
			@n_list.push node
		elsif @code.match(JPConst::R_LOC_VAR_INIT) != nil
			data = JPConst::R_LOC_VAR_INIT.match(@code)
			c_list = Array.new
			in_bracket = false
			in_s_bracket = false
			val = data[:value]

			last = 0

			for i in 0..val.length-1
				if val[i] == "["
					in_s_bracket = true
				elsif val[i] == "]"
					in_s_bracket = false
				elsif val[i] == "("
					in_bracket = true
				elsif val[i] == ")"
					in_bracket = false
				elsif val[i] == "," and !in_s_bracket and !in_bracket
					c_list.push val.slice(last, i)
					last = i + 1
				end
			end
			
			c_list.push val.slice(last, val.length)

			for i in 0..c_list.length-1
				node = DefValueNode.new
				node.value_type = data[:type]
				if i == 0
					node.name = data[:name]
					node.init_value = c_list[0]
					@n_list.push node
				end
			end
		elsif @code.match(JPConst::R_LOC_VAR) != nil
			data = JPConst::R_LOC_VAR.match(@code)
			c_list = data[:name].split(",")

			c_list.each do |name|
				node = DefValueNode.new
				node.value_type = data[:type]
				node.name = name.ltrim("\s").rtrim("\s")
				@n_list.push node
			end
		else
			node = UnparsedNode.new
			@n_list.push node
		end

		return @n_list
	end
end