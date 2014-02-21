require 'fileutils'

PATH = "decompiling\\lib_orroid.jar"

def project_run
	project_path = ARGV[1]
	put_path = project_path + "\\libs\\"
	src_path = project_path + "\\src\\"

	FileUtils.cp(PATH, put_path)
	
	name = Array.new
	count = 0
	
	File.open(project_path+"\\AndroidManifest.xml", "r") do |file|
		file.each do |line|
			if line.gsub(/\s/,'') == "<activity"
				count = 1
			elsif count == 1 && line =~ /[android]+\:+name/
				line = line[line.index("\"")+1, line.rindex("\"")-line.index("\"")-1]
				string = String.new
				
				line.split(/\./).each do |word|
					string = string + "\\" + word
				end
				
				name << string
				count = 0
			end
		end	
	end 

	path = src_path + name[0] + '.java'


	tmpfile = File.new(src_path+"blah.txt", "w")
	f = File.open(path, 'r')
	
	count = 0
	
	f.each do |line|
		tmpfile<<line
		if count == 0 && line =~ /^[import]+\s+[a-zA-Z]+/
			tmpfile << "\n"
			tmpfile << "import aaa.aaaa.orroid.*;"
			tmpfile << "\n"
			count = 1
		end
	end

	f.close
	tmpfile.close
	
	FileUtils.rm_rf(path)
	FileUtils.mv(src_path+"blah.txt", path)
	
	puts "Success"
	
end