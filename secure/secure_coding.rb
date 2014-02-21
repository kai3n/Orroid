require "find"

load "secure/xml_check.rb"
load "secure/pattern_check.rb"
load "secure/jparser.rb"
load "secure/report.rb"
load "secure/report_generator.rb"
load "secure/analysis.rb"
load "secure/var_tracer.rb"

class String
	def left(n)
		return self.slice(0, n)
	end
	
	def right(n)
		if n > self.length
			return self
		end
		
		return self.slice(self.length-n, n)
	end

	def rtrim(ch)
		while self[self.length-1] == ch
			self.chop!
		end

		return self
	end

	def ltrim(ch)
		self.reverse!
		self.rtrim(ch)

		return self.reverse
	end
end

def make_list(path, exp)
	list = Array.new
	
	Find.find(path) do |path|
		if File.directory?(path)
			if File.basename(path)[0] == ?.
				Find.prune
			else
				next
			end
		else
			if path.match(exp) != nil
				list.push path
			end
		end
	end
	
	return list
end

def do_xml_check()
	$xml_pattern.each do |pattern|
		xml_check pattern do |w|
			report = Report.new
			
			report.idx = pattern.split("/").last.split(".").first
			report.src = "/AndroidManifest.xml"
			report.klass = "AndroidManifest.xml"
			
			report.code = w
			report.line = "-"
			
			$reports.push report
		end
	end
end

def do_check(parser)
	$java_pattern.each do |pattern|
		check parser, pattern do |w|
			report = Report.new
			
			report.idx = pattern.split("/").last.split(".").first
			report.src = parser.path
			report.klass = parser.class_name
			
			report.code = w.code
			report.line = w.line_number

			if report.idx == "ORR30"
				report.info_stack = w.info_stack
			end

			$reports.push report
		end
	end
end

def sec_cod_run
	p $path

	code_list = Array.new

	Find.find($path) do |path|
		if File.directory?(path)
			if File.exist?(path+"/src") and File.exist?(path+"/AndroidManifest.xml")
				code_list += make_list(path+"/src", /.*\.java$/)
				$manifest = load_xml(path+"/AndroidManifest.xml")
			else
				next
			end
		end
	end

	$java_pattern = make_list("secure/pattern", /.*\.rb$/)
	$xml_pattern = make_list("secure/pattern_xml", /.*\.rb$/)

	puts "Project Name : #{$path}"
	puts ""
	puts "   package : #{$manifest.package}"
	puts "   minSDK  : #{$manifest.minSDK}"
	puts ""
	puts "   permissions"

	$manifest.permission.each do |p|
		puts "     -#{p}"
	end

	puts "\n"

	parsed = Array.new

	$analyzer = Analysis.new

	code_list.each do |path|
		$stdout.write "   Load - %35s... " % path.split('/').last
		
		f = File.new(path, "r")
		code = f.read
		f.close

		parser = JParser.new(path, code)
		parsed.push parser
		
		puts "ok"
	end

	$reports = Array.new

	do_xml_check()

	parsed.each do |parser|
		begin
			do_check(parser)
		rescue Exception => e
			err_msg = ""
			err_msg += "error with " + parser.path + "\n"
			err_msg += "pattern error : #{e.message}\n"
			e.backtrace.each do |line|
				err_msg += "\t#{line}\n"
			end
			f = File.new("secure/errs/"+parser.path.split("/").last+".err","w")
			f.write(err_msg)
			f.close
		end
		
		if $debug_out == true and parser.class_name != nil
			$stdout.write "   make - %28s.java.pt..." % parser.class_name
			parser.out "secure/dbg/" + parser.class_name + ".pt"
			puts "ok"
		end
	end

	make_report($reports)

	puts ""
	puts "Done!"
end