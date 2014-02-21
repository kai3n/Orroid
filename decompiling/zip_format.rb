def zip_run
	apk_name = ARGV[1]

	if apk_name == nil
		puts "Input file"
		
	elsif apk_name =~ /[a-zA-Z0-9]+\.+[apk]/
	
		f = File.open(apk_name, 'r+')

		file_size = f.size()
		string = f.read(file_size)

		android_index = string.index("AndroidManifest.xmlPK")
		classes_index = string.index("classes.dexPK")
		resource_index = string.index("resources.arscPK")

		index = [android_index, classes_index, resource_index]

		f.rewind

		for j in 0...(index.length)
			if index[j] != nil
				f.seek(index[j] - 38, IO::SEEK_SET)
				f.write("\x09\x08")
			end
		end

		f.close

		puts "Encrypted"

	else
		puts "Input file should be APK file"
	end

end