
INIT_ACCESS_FLAG = "818004"
PUBLIC_ACCESS_FLAG = "01"

class Inserting
	def Insert_defenseCode(file, jumping)
	
		size = $Dex_Format['find_class_data_off'].hex
		
		f = File.open(file, 'r')
		f.seek(size, IO::SEEK_SET)
###----------- << class data item >>--------------###
		static_field_size = f.read(1).unpack("H*")[0].to_i
		instance_field_size = f.read(1).unpack("H*")[0].to_i
		direct_methods_size = f.read(1).unpack("H*")[0].to_i
		virtual_methods_size = f.read(1).unpack("H*")[0].to_i

		#---- static_fields   ---#
		
		#---- instance_fields ---#

		f.read($Dex_Format['instance_fields']) if instance_field_size != 0
	
		#----    method       ---#
		
		
		#---- up to what library i put in the dex file ---#
		# $Dext_Format['method_ids'] : each array value refers to method id in the class
		
		next_method_id = Array.new
		
		
		if direct_methods_size == 1
			tmp_f = File.open(file, 'r')
			tmp_f.read(size + 4)
			tmp_f.read($Dex_Format['instance_fields']) if instance_field_size != 0
			tmp_f.read((integer_to_Uleb128($Dex_Format['method_ids'][0]).length + INIT_ACCESS_FLAG.length)/2)
			
			method = integer_to_Uleb128($Dex_Format['method_ids'][1])
			length = method.length
			
			count = 2
			for j in 0...(length/2)
				next_method_id[j] = method[length-count,2]
				count += 2
			end
		
			for code_off_length in 0...10 
				if next_method_id[0] == tmp_f.read(1).unpack('H*')[0]
					if next_method_id.length == 1
						break if PUBLIC_ACCESS_FLAG == tmp_f.read(1).unpack('H*')[0]
					else
						if next_method_id[1] + PUBLIC_ACCESS_FLAG == tmp_f.read(2).unpack('H*')[0]
							break
						end
					end
					code_off_length += 1
				end
			end
			puts "code_off_length = #{code_off_length}"
			
			tmp_f.close
			
			f.read(integer_to_Uleb128($Dex_Format['method_ids'][0]).length/2 + INIT_ACCESS_FLAG.length/2)
			
			code_off = f.read(code_off_length).unpack('H*')
			code_off = Uleb128_to_integer(code_off)
		else
			
		end
		f.close
		#---- Jump to data section ---#
		Inserting(code_off, file)
	end
	# data 영역에 원하는 code 집어넣는 곳
	def Inserting(data_off, file)
		puts "Find code off = 0x#{data_off.to_s(16)}"
		puts "Code starts from #{(data_off+4).to_s(16)}h"
		f = File.open(file, 'r+')
		f.seek(data_off + 2 * 4 + 4, IO::SEEK_SET) # registers + debug offset
		
		jumping = Jumping.new
		insns_size = jumping.Convert_lit_to_Big(f.read(4).unpack('H*')).to_i
		
		insert_string = ($Dex_Format['String id size'] + 10).to_s(16)
		puts "insns_size = #{insns_size}"
	
		if insns_size * 2 >= 10
			f.write("\x12\x01\x38\x01\x03\x00\x1a\x00")
			f.write([insert_string[2, 2]].pack('H*'))
			f.write([insert_string[0, 2]].pack('H*'))
		end
		f.close
		puts "Inserting Success!!"
	end
end