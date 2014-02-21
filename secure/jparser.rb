load "secure/node.rb"
load "secure/summary.rb"
load "secure/jpconst.rb"
load "secure/jppp.rb"
load "secure/jpnm.rb"

class Pair
	attr_accessor :code, :line
end

class JParser
	attr_reader :node, :doc, :doc_splited
	attr_reader :node_list, :class_name
	
	attr_reader :path, :method_name
	
	def initialize(path, code)
		@doc = code
		@doc_splited = Array.new
		@path = path
		
		@working_line = ""
		@working_line_number = 0
		@working_real_line_number = 0
		
		@depth = 0
		
		@node = NodeT.new
		@working_node = @node
		
		@node_list = Array.new
		@node_list[0] = @node
		@flags = Hash.new
		
		@dflag = JPConst::NoIndent

		@analyzer = $analyzer

		@function_name = ""

		@depth = 0

		@class_name = ""
		
		parse
	end
	
	def parse
		jppp = JPPP.new

		@doc_splited = jppp.pre_process(@doc)

		if $debug_out
			txt = ""

			for i in 0..@doc_splited.length-1
				txt += "line number" + (i+1).to_s + "\n"
				txt += "real line number" + (@doc_splited[i].line+1).to_s + "\n"
				txt += @doc_splited[i].code + "\n"
			end

			f = File.new(path + ".dpp", "w")
			f.write(txt)
			f.close
		end

		for i in 0..@doc_splited.length-1
			begin
				parse_line(i, @doc_splited[i])
			rescue Exception => e
				err_msg = ""
				err_msg += "ParseError : #{e.message}" + "\n"
				err_msg += "File : #{@path}" + "\n"
				err_msg += "Code : #{@doc_splited[i].code} (#{@doc_splited[i].line + 1})" + "\n"
				
				e.backtrace.each do |line|
					err_msg += "   #{line}" + "\n"
				end
				
				f = File.new("secure/errs/"+@path.split("/").last+i.to_s+".er", "w")
				f.write(err_msg)
				f.close
			end
		end
	end
	
	def parse_line(line_number, pair)
		n_list = Array.new
		
		@working_line = pair.code
		@working_line_number = line_number + 1
		@working_real_line_number = pair.line

		jpnm = JPNM.new
		
		if @working_line == "{" or @working_line == "}"
			if @working_line.include?("{")
				@depth += 1
				@working_node = @node_list.last
			elsif @working_line.include?("}")
				@depth -= 1
				@working_node = @working_node.parent
			end
		else
			if @working_node.type == NodeType::DefClass
				n_list = jpnm.making_node_1(@working_line)
			else
				n_list = jpnm.making_node_2(@working_line)
			end

			if n_list.length != 0
				if n_list[0].type == NodeType::DefClass
					@class_name = n_list[0].name
					@analyzer.insert_class(n_list[0])
				elsif n_list[0].type == NodeType::DefFunction
					@function_name = n_list[0].name
					@analyzer.insert_method(@class_name, n_list[0])
				elsif n_list[0].type == NodeType::CallFunc
					@analyzer.insert_callee(@class_name, @function_name, n_list[0], @node_list)
				elsif n_list[0].type == NodeType::DefValue
					if @class_name != nil
						n_list.each do |node|
							@analyzer.values[@class_name].push node
						end
					end
				end

				n_list.each do |node|
					push_node(node)
				end
				
				if @flags["single_line_indent"] == true
					@working_node = @working_node.parent
					@flags["single_line_indent"] = false
				end
				
				if @dflag == JPConst::SingleLineIndent
					@working_node = node
					@flags["single_line_indent"] = true
				end
			end
		end
	end
	
	def push_node(node)
		node.code = @working_line
		node.line_number = @working_real_line_number
		node.class_name = @class_name
		node.prev = @working_node.children.last
		node.level = @depth
		
		node.method_name = @function_name


		@node_list.push node
		@working_node.add node
	end
	
	def out(path)
		f = File.new(path, "w")
			print_node @node, 0 do |line|
				f.write(line + "\n")
			end
		f.close
	end
	
	def print_node(node, depth, &block)
		msg = "   "
		depth.times { msg += "   " }
		
		case node.type
			when NodeType::None
				msg += "BasicNode" + "#{node.parent}"
			when NodeType::Unparsed
				msg += "Unparsed - #{node.code}" + "#{node.parent}"
			when NodeType::Package
				msg += "Package - package #{node.package}" + "#{node.parent}"
			when NodeType::Import
				msg += "Import - package #{node.package}" + "#{node.parent}"
			when NodeType::DefClass
				msg += "Class - name : #{node.name} / attributes : #{node.attrs} / super : #{node.extends} / implements : #{node.implements}" + "#{node.parent}"
			when NodeType::DefValue
				msg += "DefValue - name : #{node.name} / type : #{node.value_type} / init : #{node.init_value}" + "#{node.parent}"
			when NodeType::DefFunction
				msg += "Function - name : #{node.name} / accessor : #{node.accessor} / args : #{node.args} / return : #{node.return}" + "#{node.parent}"
			when NodeType::If
				msg += "If - expression : #{node.expression}" + "#{node.parent}"
			when NodeType::Else
				msg += "Else" + "#{node.parent}"
			when NodeType::While
				msg += "While - condition : #{node.condition}" + "#{node.parent}"
			when NodeType::For
				msg += "For - init : #{node.init} / condition : #{node.condition} / aftherthought : #{node.afterthought}" + "#{node.parent}"
			when NodeType::Try
				msg += "Try" + "#{node.parent}"
			when NodeType::Catch
				msg += "Catch - arg : #{node.arg}" + "#{node.parent}"
			when NodeType::Throw
				msg += "Throw - exception : #{node.exception}" + "#{node.parent}"
			when NodeType::Finally
				msg += "Finally" + "#{node.parent}"
			when NodeType::Operation
				msg += "Operation - a : #{node.a} / b : #{node.b}" + "#{node.parent}"
			when NodeType::CallFunc
				msg += "CallFunc - a : #{node.a} / b : #{node.b}" + "#{node.parent}"
			when NodeType::Return
				msg += "Return" + "#{node.parent}"
		end
		
		if block == nil
			puts msg
		else
			block.call msg
		end
		
		node.children.each do |c_node|
			print_node(c_node, depth + 1, &block)
		end
	end
end