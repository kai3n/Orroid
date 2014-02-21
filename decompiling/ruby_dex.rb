load 'decompiling/jumping.rb'
load 'decompiling/check_sig.rb'
load 'decompiling/zip_.rb'

$Dex_Format = Hash.new
$binary = ["0000", "0001", "0010", "0011", "0100", "0101", "0110", "0111", "1000", "1001", "1010", "1011", "1100", "1101", "1110", "1111"]
						 
# later make them together
def Uleb128_to_integer(offset) # this offset could be string, not Array!!
	jumping = Jumping.new
	tmp = jumping.Convert_lit_to_Big(offset)
	
	length = tmp.length
	code_off = Array.new
	tmp_off = Array.new
	
	for j in 0...length
		code_off << tmp[j, 1]
	end

	for j in 0...(tmp.length)
		$binary.each do |binary|
			if code_off[j].hex == binary.to_i(2)
				code_off[j] = binary
				break
			end
		end
		tmp_off << code_off[j-1] + code_off[j] if j % 2 != 0
	end
	for j in 0...(tmp_off.length)
		if j == 0
			tmp_off[j].slice! "0" 
			off = tmp_off[j]
		else
			tmp_off[j].slice! "1"
			off += tmp_off[j]
		end
	end	
	return off.to_i(2)
end	
def integer_to_Uleb128(integer)
	hex = integer.to_s(16)
	code_off = Array.new
	
	for j in 0...(hex.length)
		code_off << hex[j]
	end
	
	for j in 0...(hex.length)
		$binary.each do |binary|
			if code_off[j].hex == binary.to_i(2)
				code_off[j] = binary
				break
			end
		end
	end
	
	for j in 0...(hex.length)
		tmp = code_off[0] if j == 0
		tmp += code_off[j] unless j == 0
	end

	# make tmp.length be seven times
	until tmp.length % 7 == 0
		tmp = "0" + tmp
	end	
	
	length = tmp.length / 7
	
	code = Array.new
	# divide $binary string into length 7 and make each length 8
	
	if length == 1
		code[0] = tmp[0, 7]
		code[0] = ("0" + code[0]).to_i(2).to_s(16)
		code[0] = "0" + code[0] if code[0].length == 1
	else
		count = 0
		start = 0
		for j in 0...(length)
			if !code[count] && tmp[start, 7].to_i(2) == 0
				start += 7
				next
			end
			code[count] = tmp[start, 7]
			code[count] = "0" + code[count] if count == 0
			code[count] = "1" + code[count] unless count == 0
			code[count] = code[count].to_i(2).to_s(16)
			code[count] = "0" + code[count] if code[count].length == 1
			start += 7
			count +=1
		end
	end

	for j in 0...code.length
		tmp = code[j] if j == 0
		tmp += code[j] unless j == 0
	end
	
	# puts "Uleb128 = #{tmp}"
	return tmp #uleb128 in Big Endian
end

def dex_run
	input_file = ARGV[1] #get input file
	if input_file == nil
		puts "Input file"
		
	elsif input_file =~ /[a-zA-Z0-9]+\.+[apk]/
		zipper = Zipper.new(input_file, ARGV[2])
		file_string_path = zipper.unzipping

		begin
			file_string = file_string_path + "\\classes.dex"
			
			jumping = Jumping.new
			f = File.open(file_string, 'r')

			puts "Magic Number = #{$Dex_Format['Magic Number'] = f.read(8).unpack("H*")}"
			puts "Checksum = #{$Dex_Format['Checksum'] = f.read(4).unpack("H*")}"
			puts "Signature = #{$Dex_Format['Signature'] = f.read(20).unpack("H*")}"
			puts "file size = #{$Dex_Format['File size'] = jumping.Convert_lit_to_Big(f.read(4).unpack("H*")).hex}"
			f.read(5*4)	
			puts "String id size = #{$Dex_Format['String id size'] = jumping.Convert_lit_to_Big(f.read(4).unpack("H*")).hex}"
			puts "String id off = #{$Dex_Format['String id off'] = jumping.Convert_lit_to_Big(f.read(4).unpack("H*"))}"
			puts "Type id size = #{$Dex_Format['Type id size'] = jumping.Convert_lit_to_Big(f.read(4).unpack("H*")).hex}"
			puts "Type id off = #{$Dex_Format['Type id off'] = jumping.Convert_lit_to_Big(f.read(4).unpack("H*"))}"
			puts "Proto id size = #{$Dex_Format['Proto id size'] = jumping.Convert_lit_to_Big(f.read(4).unpack("H*")).hex}"
			puts "Proto id off = #{$Dex_Format['Protoe id off'] = jumping.Convert_lit_to_Big(f.read(4).unpack("H*"))}"
			puts "Field id size = #{$Dex_Format['Field id size'] = jumping.Convert_lit_to_Big(f.read(4).unpack("H*")).hex}"
			puts "Field id off = #{$Dex_Format['Field id off'] = jumping.Convert_lit_to_Big(f.read(4).unpack("H*"))}"
			puts "Method id size = #{$Dex_Format['Method id size'] = jumping.Convert_lit_to_Big(f.read(4).unpack("H*")).hex}"
			puts "Method id off = #{$Dex_Format['Method id off'] = jumping.Convert_lit_to_Big(f.read(4).unpack("H*"))}"
			puts "Class def size = #{$Dex_Format['Class def size'] = jumping.Convert_lit_to_Big(f.read(4).unpack("H*")).hex}"
			puts "Class def off = #{$Dex_Format['Class def off'] = jumping.Convert_lit_to_Big(f.read(4).unpack("H*"))}"
			
			f.close
			
			check = jumping.Jump_to_String(file_string)
			if check == 1	
				jumping.Jump_to_Type(file_string)
				jumping.Jump_to_Field(file_string)	
			
				check_sig = Check_sig.new
				check_sig.calSignature(file_string)
			
				zipper.zipping()
			else
				puts "========================================="
				puts "Can't find the library"
			end
		rescue
		end
	else
		puts "Input file should be APK file"
	end
end