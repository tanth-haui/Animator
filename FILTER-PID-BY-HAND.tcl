GNS_exe_command "s\[0\]:?sel pid @se"
array set pid [GNS_get_selection model 0]
set pid_list $pid(PIDS)
set num [llength $pid_list]
GNS_exe_command "sel res"
set list_0 {}
set list_1 {}
set geopath [ GNS_get_system_var 0 GEOFILEPATH ]
for {set k 0} {$k< [expr $num]} {incr k 1} {
array set b [GNS_get_property 0 @si]
array set b1 [GNS_get_property 1 @si]
set list_0 [linsert $list_0 0 $b(ID)]
set list_1 [linsert $list_1 0 $b1(ID)]
if { $b1(THICK) == $b(THICK)} {
GNS_exe_command {s[1]:slo swi off}
				GNS_exe_command "era pid $b(ID)"
				GNS_exe_command {
				s[1]:slo swi on
				s[0]:slo swi off
				}
GNS_exe_command "era pid $b1(ID)"
GNS_exe_command {s[0]:slo swi on}
}
if { $b1(THICK) != $b(THICK)} {
	set fp [ open "$geopath/COUPLE-PID($k).csv" "WRONLY CREAT EXCL"]
	puts $fp "$b(ID),$b1(ID)"
	
	close $fp
	GNS_exe_command {s[1]:slo swi off}
				GNS_exe_command "era pid $b(ID)"
				GNS_exe_command {
				s[1]:slo swi on
				s[0]:slo swi off
				}
	GNS_exe_command "era pid $b1(ID)"
	GNS_exe_command {s[0]:slo swi on}
}
}
###
