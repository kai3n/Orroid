load 'decompiling/inserting.rb'

INSTANCE_ACCESS_FLAG = "02"

class Jumping
	def Convert_lit_to_Big(string) # now this string is Array
		length = string[0].length
		case length
		when 2
			return string[0][0,2]
		when 4
			return (string[0][2,2] + string[0][0,2])
		when 6
			return (string[0][4,2] + string[0][2,2] + string[0][0,2])
		when 8
			return (string[0][6,2] + string[0][4,2] + string[0][2,2] + string[0][0,2])
		end
	end
	def Jump_to_String(file)
		offset = $Dex_Format['String id off'].hex
		size = $Dex_Format['String id size']
		findout_string = 0

		f = File.open(file, 'r') # reading bytes at once
		f.seek(offset, IO::SEEK_SET) #jump to where string table starts
	
		for j in 0...(size)
			string_offset = Convert_lit_to_Big(f.read(4).unpack('H*')).hex #string offset
			# go in to the data section
			f.seek(string_offset, IO::SEEK_SET)
			string_size = f.read(1).unpack('H*')
			# it could be bug -> string length is Uleb128, means string_size could be more than one byte
			if(f.read(string_size[0].hex) == "Laaa/aaaa/orroid/Orroid_bob;")
			#Laaa/aaaa/orroid/Orroid_bob;
				findout_string = 1
			
				$Dex_Format['find_string_id'] = j
				puts "==============================================="
				puts "Find String id = #{$Dex_Format['find_string_id']}"
				break
			end
			offset += 4
			f.seek(offset, IO::SEEK_SET)			
		end
		f.close
		return findout_string
	end
	
	def Jump_to_Type(file)
		offset = $Dex_Format['Type id off'].hex
		size = $Dex_Format['Type id size']
		
		f = File.open(file, 'r')
		f.seek(offset, IO::SEEK_SET)
		
		for j in 0...(size)
			if Convert_lit_to_Big(f.read(4).unpack('H*')).hex == $Dex_Format['find_string_id']
				$Dex_Format['find_type_id'] = j # get type id
				puts "Find Type id = #{$Dex_Format['find_type_id']}"
				break
			end
		end	
		f.close
	end
	
	def Jump_to_Field(file)
	
		offset = $Dex_Format['Field id off'].hex
		size = $Dex_Format['Field id size']
		
		f = File.open(file, 'r')
		f.seek(offset, IO::SEEK_SET)
			
		instance_field = Array.new
		
		for j in 0...(size)
			tmp = Convert_lit_to_Big(f.read(2).unpack('H*')).hex
	
			instance_field << j if tmp == $Dex_Format['find_type_id']
			break if tmp > $Dex_Format['find_type_id']
			f.read(6)
		end
		
		puts "Find number of Field = #{instance_field.length}"
		
		# get length of instance_fields in class_data_item struct
		if instance_field.length > 0
			field_ids = Array.new
			count = 0
			tmp = nil
			instance_field.each do |id|
				field_ids << integer_to_Uleb128(id)
				
				if count == 0
					tmp = Convert_lit_to_Big(field_ids) + INSTANCE_ACCESS_FLAG
				elsif count != 0
					diff = (field_ids[count].to_i(16) - field_ids[count-1].to_i(16)).to_s(16)
					diff = "0" + diff if diff.length == 1
					tmp = tmp + diff + INSTANCE_ACCESS_FLAG
				end
				count += 1
			end	
	
			$Dex_Format['instance_fields'] = tmp.length/2
			puts "Instance_fields = #{$Dex_Format['instance_fields']}"
		else
			puts "Instance_fields = NO EXISTS"
		end
		f.close
		Jump_to_Method(file)
	end
	def Jump_to_Method(file)
		offset = $Dex_Format['Method id off'].hex
		size = $Dex_Format['Method id size']
		
		f = File.open(file, 'r')
		f.seek(offset, IO::SEEK_SET)
		
		method_ids = Array.new
		$Dex_Format['method_ids'] = method_ids
		for j in 0...(size)
			if(Convert_lit_to_Big(f.read(2).unpack('H*')).hex == $Dex_Format['find_type_id'])
				method_ids << j
			end
			f.read(6)
		end
		f.close
		Jump_to_Class(file)
	end
	
	def Jump_to_Class(file)
		offset = $Dex_Format['Class def off'].hex
		size = $Dex_Format['Class def size']
	
		f = File.open(file, 'r')
		f.seek(offset, IO::SEEK_SET)
		
		# 32bytes for each class def
		
		for j in 0...(size)
			
			class_idx = Convert_lit_to_Big(f.read(4).unpack('H*')).hex
			
			if class_idx == $Dex_Format['find_type_id']
				f.seek(20, IO::SEEK_CUR) # 4 * 5
				data_off = Convert_lit_to_Big(f.read(4).unpack("H*"))
				$Dex_Format['find_class_data_off'] = data_off
				puts "Find Class data off = #{$Dex_Format['find_class_data_off']}"
				f.close
				inserting = Inserting.new
				inserting.Insert_defenseCode(file, self)
				break
			else
				f.read(28)
			end
		end	
	end
end