class SumClass
	attr_accessor :mtd, :variable
	attr_accessor :name, :parent
	attr_accessor :node
	
	def initialize(node_cls)
		@name = node_cls.name
		
		if node_cls.extends != nil
			@parent = node_cls.extends
		elsif node_cls.implements != nil
			@parent = node_cls.implements
		end

		@mtd = Array.new

		@variable = Array.new

		@node = node_cls
	end

	def add_method(sum_method)
		@mtd.push sum_method
	end

	def add_variable(sum_variable)
		@variable.push sum_variable
	end
end

class SumMethod
	attr_accessor :name, :parameter, :return, :variable, :callee, :attrs, :node

	def initialize(node_mtd)
		@name = node_mtd.name

		@parameter = Array.new
		tmp = node_mtd.args.clone
		tmp = tmp.split(",")
		tmp.each do |arg|
			arg = arg.ltrim("\s")
			arg = arg.rtrim("\s")
			arg = arg.split("\s")
			@parameter.push SumParameter.new(arg[1], arg[0])
		end

		@attrs = node_mtd.attrs

		@return = node_mtd.return

		@variable = Array.new

		@callee = Array.new

		@node = node_mtd
	end
end

class SumParameter
	attr_accessor :name, :type

	def initialize(name, type)
		@name = name

		@type = type
	end
end

class SumVariable
	attr_accessor :name, :type, :log, :value

	def initialize(name, type)
		@name = name

		@type = type

		@log = Array.new

		@value = ""
	end
end