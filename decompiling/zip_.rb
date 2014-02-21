# encoding: utf-8
require './decompiling/zip'
require 'fileutils'
require 'find'


class Zipper
	def initialize(input_file, output) #default path == input file path
		@full_path = input_file
		@dir_path = File.dirname(input_file)
		@dir_name = input_file[0, input_file.rindex(".")]
		@apk_file_name = "output_" + File.basename(input_file)
		@apk_path = File.dirname(input_file) + "\\" + @apk_file_name
		@apk_path = output if output != nil
		
		#dir_name : unzipped files will be located, full relative path
		#apk_file_name : made apk file
		#apk_path = where to be made
	end
	def unzipping()
		FileUtils.rm_rf(@dir_name) if File.exist?(@dir_name)	
		FileUtils.mkdir_p(@dir_name)
		begin
			#--------- unzip zip file ---------
			Zip::File.open(@full_path) do |zip_file|
				zip_file.each do |f|
					f_path = File.join(@dir_name+"\\", f.name)
					FileUtils.mkdir_p(File.dirname(f_path))
					zip_file.extract(f, f_path) unless File.exist?(f_path)
				end
			end
			return @dir_name
		rescue
			puts "Can't find a file"
		end
	end
	def zipping()
		
		if File.exist?(@apk_path)
			puts "--Same file exists ==> delete it--"
			FileUtils.rm_rf(@apk_path)
		end
		Zip::File.open(@apk_path, Zip::File::CREATE)do |zipfile|
			Find.find(@dir_name) do |path|
				if path != @dir_name
					if File.dirname(path) != @dir_name +"/META-INF" && File.basename(path) != "META-INF"
						zipfile.add(path.sub(@dir_name+'/', ''), path)
					end
				end
			end
		end
		FileUtils.rm_rf(@dir_name)
		
		puts "New APK file is made : #{@apk_file_name}"
	end
end