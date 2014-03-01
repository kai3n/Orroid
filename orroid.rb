load "secure/secure_coding.rb"
load "decompiling/ruby_dex.rb"
load "decompiling/zip_format.rb"
load "decompiling/put_lib.rb"
load "help.rb"

$flag = "K";

if ARGV[0] == "-d" || ARGV[0] == 	"--dex"
	dex_run
elsif ARGV[0] == "-z" || ARGV[0] == "--zipformat"
	zip_run
elsif ARGV[0] == "-D" || ARGV[0] == "--Debug"
	$debug_out = true
	$path = ARGV[1].to_s
	sec_cod_run
elsif ARGV[0] == "-s"
	if ARGV[1] == "-K" || ARGV[1] == "-E"
		$flag = "E" if ARGV[1] == "-E"
		$path = ARGV[2].to_s 
	else
		$path = ARGV[1].to_s 
	end
	sec_cod_run
elsif ARGV[0] == "-p" || ARGV[0] == "--project"
	project_run
elsif ARGV[0] == "-h" || ARGV[0] == "--help"
	help
else
	help
end