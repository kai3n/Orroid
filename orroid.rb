load "secure/secure_coding.rb"
load "decompiling/ruby_dex.rb"
load "decompiling/zip_format.rb"
load "help.rb"

$flag = "K";

if ARGV[0] == "-d" || ARGV[0] == 	"--dex"
	dex_run
elsif ARGV[0] == "-z" || ARGV[0] == "--zipformat"
	zip_run
elsif ARGV[0] == "-doyouwanttodebugthisprogram"
	$debug_out = true
	$path = ARGV[1].to_s
	sec_cod_run
elsif ARGV[0] == "-s"
	if ARGV[1] == "-K" || ARGV[1] == "-E"
		if ARGV[1] == "-E"
			$language = "E"
		end

		$path = ARGV[2].to_s 
	else
		$path = ARGV[1].to_s 
	end
	
	sec_cod_run
elsif ARGV[0] == "-h" || ARGV[0] == "--help"
	help
else
	help
end