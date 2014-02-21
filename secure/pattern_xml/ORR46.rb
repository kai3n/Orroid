bad_permissions = [
	"READ_CALENDAR",
	"WRITE_CALENDAR"
]

$manifest.permission.each do |p|
	bad_permissions.each do |bp|
		if p.include?(bp) == true
			$report.push p
		end
	end
end