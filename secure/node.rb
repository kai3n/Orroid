class NodeType
	Unparsed = -1
	None = 0
	
	DefClass = 1
	DefFunction = 2
	DefValue = 3
	UpdatedValue = 4
	
	If = 10
	Else = 11
	While = 12
	For = 13
	
	Try = 20
	Catch = 21
	Throw = 22
	Finally = 23
	
	Operation = 30
	CallFunc = 31
	
	Return = 40
	
	Import = 101
	Package = 102
end

class NodeT
	attr_accessor :type
	attr_accessor :children, :parent
	attr_accessor :code, :line_number
	attr_accessor :class_name, :method_name
	attr_accessor :prev, :next
	attr_accessor :level
	

	def initialize
		@type = NodeType::None
		@children = Array.new
		@parent = nil
		
		@code = ""
		@class_name = ""
		@method_name = ""

		@level = 0
	end
	
	def add(obj)
		obj.parent = self
		@children.push obj
	end
	
	def tour(&block)
		yield self
		
		@children.each do |child|
			child.tour(&block)
		end
	end
	
	def filter(type, &block)
		@children.each do |node|
			if node.type == type
				yield node
			end
		end
	end
end

class UnparsedNode < NodeT
	def initialize
		super
		@type = NodeType::Unparsed
	end
end

class ImportNode < NodeT
	attr_accessor :package
	
	def initialize
		super
		@type = NodeType::Import
	end
end

class PackageNode < ImportNode
	def initialize
		super
		@type = NodeType::Package
	end
end

class DefineNode < NodeT
	attr_accessor :name
	attr_accessor :attrs
	attr_accessor :accessor
	
	def initialize
		super
		@accessor = ""
		@attrs = ""
		@name = ""
	end
end

class DefClassNode < DefineNode
	attr_accessor :extends, :implements
	
	def initialize
		super
		@type = NodeType::DefClass
	end
end

class DefFunctionNode < DefineNode
	attr_accessor :args
	attr_accessor :return
	
	def initialize
		super
		@type = NodeType::DefFunction
	end
end

class DefValueNode < DefineNode
	attr_accessor :value_type
	attr_accessor :init_value
	attr_accessor :info_stack
	
	def initialize
		super
		@type = NodeType::DefValue
	end
end

#S_M
class UpdatedValueNode < NodeT
	attr_accessor :updated_value

	def initialize
		super
		@type = NodeType::UpdatedValue
	end
end
#S_M

class IfNode < NodeT
	attr_accessor :expression
	
	def initialize
		super
		@type = NodeType::If
	end
end

class ElseNode < NodeT
	def initialize
		super
		@type = NodeType::Else
	end
end

class LoopNode < NodeT
	attr_accessor :condition
	
	def initialize
		super
		@type = NodeType::While
	end
end

class ForNode < LoopNode
	attr_accessor :init, :afterthought
	
	def initialize
		super
		@type = NodeType::For
	end
end

class TryNode < NodeT
	def initialize
		super
		@type = NodeType::Try
	end
end

class CatchNode < NodeT
	attr_accessor :arg
	
	def initialize
		super
		@type = NodeType::Catch
	end
end

class ThrowNode < NodeT
	attr_accessor :exception
	
	def initialize
		super
		@type = NodeType::Throw
	end
end

class FinallyNode < NodeT
	def initialize
		super
		@type = NodeType::Finally
	end
end

class OperationNode < NodeT
	attr_accessor :a, :b, :op
	
	def initialize
		super
		@type = NodeType::Operation
	end
end

class CallFuncNode < NodeT
	attr_accessor :a, :b
	attr_accessor :param
	
	def initialize
		super
		@type = NodeType::CallFunc
	end
end

class ReturnNode < NodeT
	attr_accessor :value
	
	def initialize
		super
		@type = NodeType::Return
	end
end