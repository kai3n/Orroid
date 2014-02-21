bad_permissions = [
	"READ_HISTORY_BOOKMARKS", 
	"WRITE_HISTORY_BOOKMARKS"
]

$manifest.permission.each do |p|
	bad_permissions.each do |bp|
		if p.include?(bp) == true
			$report.push p
		end
	end
end