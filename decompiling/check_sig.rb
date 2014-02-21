require 'digest/sha1'
require 'zlib'


class Check_sig
	def sig_ones_complement(num)
		  significant_bits = num.to_s(2).length
		  next_smallest_pow_2 = 2**(significant_bits-1)
		  xor_mask = (2*next_smallest_pow_2)-1
		  return ~(num ^ xor_mask)
	end
	def calChecksum(file, size, signature) # use Adler32 for making checksum
		f = File.open(file, 'r+')
		f.read(12) # Magic(8) + Checksum(4)
		
		f.write([signature].pack('H*'))
		f.seek(-20, IO::SEEK_CUR)
	
		num = Array.new
		f.read(size-12).unpack('C*') do |byte|
			byte = sig_ones_complement(byte) if byte.to_s(2).length == 8	# byte.to_s(2).index("1") == 0 && 
			num << byte 
		end
				
		length = num.length
	# #--- Adler32 Algorithm ---
		s1 = 1
		s2 = 0
		count = 0
		
		while length > 0
			n = 3800
			if n > length
				n = length
			end
			length = length - n
			while n > 0
				s1 = s1 + (num[count] & 0xff)
				s2 = s2 + s1
				n = n - 1
				count = count + 1
			end			
			s1 = s1 % 65521
			s2 = s2 % 65521
		end
	
		sum = ((s2 << 16) | s1) & 0xffffffff
		
		length = sum.to_s(2).length
	
		for j in 0...4
			tmp = (sum >> j * 8).to_s(2)
			
			tmp = tmp[length-((j+1) * 8), 8].to_i(2).to_s(16) if j != 3
			tmp = tmp.to_i(2).to_s(16) if j == 3
			
			tmp = "0" + tmp if tmp.length != 2

			checksum = tmp if j == 0
			checksum += tmp unless j == 0
		end
		
		
		f.seek(8, IO::SEEK_SET)
		f.write([checksum].pack('H*'))
		f.close
		
		puts "Checksum = #{checksum}"
	end
	def calSignature(file)
		
		file_size = $Dex_Format['File size']
		
		f = File.open(file, 'r')		
		f.read(32)

		signature = Digest::SHA1::hexdigest (f.read(file_size - 32))
	
		raise "Error in Making Signature"	if signature.length != 40
		
		f.close
		puts "Signature = #{signature}"
	
		calChecksum(file, file_size, signature)
	end
end