#JPPP : JParserPreProcessor
class JPPP
	def initialize
		@code_0 = ""
		@code_1 = Array.new
		@code_2 = Array.new
		@code_3 = Array.new
		@code_4 = Array.new
	end

	def pre_process(code)
		@code_0 = code

		level1

		level2

		level3

		level4

		return @code_4
	end

	def level1
		@code_1 = @code_0.lines.to_a

		for i in 0..@code_1.length-1
			begin
				data = @code_1[i].match(/(?<a>.*\/\/).*/)

				if data != nil
					if @code_1[i].match(/".*\/\/.*"/) == nil
						@code_1[i] = data[:a]
					end
				end
			rescue
				@code_1[i] = ""
			end
		end
	end

	def level2
		@code_2 = @code_1.clone

		for i in 0..@code_2.length-1
			if @code_2[i].include?("@Override")
				@code_2[i] = @code_2[i].gsub("@Override", "")
			end

			if @code_2[i].include?("@SuppressLint")
				@code_2[i] = ""
			end

			@code_2[i] = @code_2[i].gsub("{", "eol\n{\n")
			@code_2[i] = @code_2[i].gsub("}", "\n}\n")
			@code_2[i] = @code_2[i].gsub(";", ";\n")
			data = @code_2[i].match(/\/\*.*/)
			
			if data != nil
				if @code_2[i].match(/".*\/\*.*"/) == nil
					@code_2[i] = @code_2[i].gsub("/*", "\n/*\n")
				end
			end

			@code_2[i] = @code_2[i].gsub("*/", "\n*/\n")
		end
	end

	def level3
		for i in 0..@code_2.length-1
			@code_3.push @code_2[i].split("\n")
		end
	end

	def level4
		comment = false
		endline = false
		prefix = ""

		for i in 0..@code_3.length-1
			for j in 0..@code_3[i].length-1
				line = @code_3[i][j].clone
				line = line.rtrim("\n")
				line = line.rtrim("\t")
				line = line.rtrim("\s")
				line = line.ltrim("\s")
				line = line.ltrim("\t")

				while line.sub!("\t", "") != nil
				end

				while true
					if line[0] == nil
						break
					end
					
					if line[0].match(/[a-zA-Z0-9@_{}\/*]/) == nil
						line.reverse!
						line.chop!
						line.reverse!
					else
						break
					end
				end

				data = line.match(/(?<a>.*)\/\/.*/)
		
				if data != nil
					if line.match(/".*\/\/.*"/) == nil
						line = data[:a]
					end
				end

				if comment == false
					if line.include?("/*") and line.length == 2
						line = ""
						comment = true
					end
				else
					if line.include?("*/")
						line = ""
						comment = false
					else
						line = ""
					end
				end

				endline = false

				cpline = line.clone

				JPConst::EndLine.each do |t|
					if line.right(t.length) == t
						if t == "eol"
							line.chop!
							line.chop!
							line.chop!
						end
					
						endline = true
						break
					end
				end

				if endline == false
					prefix += line
					next
				end

				if line.length > 0
					line = prefix + line
					
					if line.include?("}") and line.length > 1
						pair = Pair.new
						pair.line = i
						pair.code = line.split("}")[0]
						@code_4.push(pair)

						pair = Pair.new
						pair.line = i
						pair.code = "}"
						@code_4.push(pair)
					else
						pair = Pair.new
						pair.line = i
						pair.code = line
						@code_4.push(pair)
					end

					prefix = ""
				else
					if cpline == "eol"
						line = prefix
						pair = Pair.new
						pair.line = i
						pair.code = line
						@code_4.push(pair)
					end

					prefix = ""
				end
			end
		end
	end
end