class Analysis
	attr_accessor :structure, :values
	
	def initialize
		@structure = Hash.new
		@values = Hash.new
	end

	def insert_class(node_cls)
		sc = SumClass.new(node_cls)
		@structure[node_cls.name] = sc
		@values[node_cls.name] = Array.new
	end

	def insert_method(class_name, node_mtd)
		sm = SumMethod.new(node_mtd)
		@structure[class_name].add_method sm
	end

	def insert_callee(class_name, method_name, node_callfunc, node_list)
		caller = nil

		@structure[class_name].mtd.each do |sm|
			if sm.name == method_name
				caller = sm
				break
			end
		end

		if node_callfunc.a != nil
			if @structure.keys.include?(node_callfunc.a)
				caller.callee.push(node_callfunc.a + "." + node_callfunc.b)
			else
				if node_callfunc.a == "super"
					if @structure.keys.include?(@structure[class_name].parent)
						caller.callee.push(@structure[class_name].parent + "." + node_callfunc.b)
					end
				end
			end
		else
			flag = false

			@structure[class_name].mtd.each do |sm|
				if sm.name == node_callfunc.b
					flag = true
					break
				end
			end

			if flag
				caller.callee.push(class_name + "." + node_callfunc.b)
			else
				if @structure[@structure[class_name].parent] != nil
					@structure[@structure[class_name].parent].mtd.each do |sm|
						if sm.name == node_callfunc.b
							flag = true
							break
						end
					end
				end

				if flag
					caller.callee.push(@structure[class_name].parent + "." + node_callfunc.b)
				else
					if node_callfunc.b == "this"
						caller.callee.push(class_name + "." + class_name)
					elsif node_callfunc.b == "super"
						if @structure.keys.include?(@structure[class_name].parent)
							caller.callee.push(@structure[class_name].parent + "." + @structure[class_name].parent)
						end
					end
				end
			end
		end
	end

	def print_function_list
		txt = ""

		@structure.keys.each do |sc|
			@structure[sc].mtd.each do |sm|
				txt += @structure[sc].name + "." + sm.name + "\n"
			end
		end

		f = File.new($path + ".functionlist", "w")
		f.write(txt)
		f.close
	end

	def print_caller_callee
		txt = "digraph callercallee {\n"

		@structure.keys.each do |sc|
			@structure[sc].mtd.each do |sm|
				if sm.callee.length != 0
					# txt += "caller : " + @structure[sc].name + "." + sm.name + "\n"

					sm.callee.each do |callee|
						txt += "\t\"" + @structure[sc].name + "." + sm.name + "\"" + " -> " + "\"" + callee + "\"" + "\n"
						# txt += "\tcallee : " + callee + "\n"
					end
				end
			end
		end

		txt += "}"

		f = File.new($path + ".callercallee", "w")
		f.write(txt)
		f.close
	end
end