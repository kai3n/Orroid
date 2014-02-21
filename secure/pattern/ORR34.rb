#
# (Use of a Broken or Riscky Cryptographic Algorithm
#

cipList = ["RC2", "RC4", "RC5", "RC6", "MD4", "MD5", "SHA1", "DES"]

$parser.node.tour do |node|
	cipList.each do |alg|	
		str = "Cipher.getInstance(\"" + alg + "\")"
		if node.code.include?(str) == true
			$report.push node
		end
	end
end