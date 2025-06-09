
set pid_list { 
7434200
	}
set num_model [llength $pid_list]
GNS_exe_command "opt ech ++++ $num_model ++++ $num_model ++++ $num_model ++++ $num_model ++++ $num_model ++++ $num_model ++++ $num_model"
# lay cua sanko
set pid_sanko_list {
7431200
	}
set num_sanko [llength $pid_sanko_list]
set list_0 {}
set list_1 {}
for {set k 0} {$k< [expr $num_model]} {incr k 1} {
array set b [GNS_get_property 0 [lindex $pid_list $k]]
array set a1 [GNS_get_property 1 [lindex $pid_sanko_list $k]]
GNS_exe_command "opt ech ++++++ $k ++++++ $k ++++++ $k ++++++ $k ++++++ $k ++++++ $k ++++++ $k ++++++ $k"
set ele_cod 0
set num_sanko [llength $pid_sanko_list]
GNS_exe_command "era slo 1"
GNS_exe_command "era pid $b(ID)"
GNS_exe_command "era swap"
array set phamvi [GNS_get_model_size 0 active]
#puts "0 PID $b(ID) : $phamvi(MINX) $phamvi(MINY) $phamvi(MINZ) $phamvi(MAXX) $phamvi(MAXY) $phamvi(MAXZ)"
GNS_exe_command "add slo 1"
GNS_exe_command "add all"
for {set j [expr $k+1]} {$j<=[expr $num_sanko]} {incr j 1} {
	GNS_exe_command "opt ech ++++++ $j ++++++ $j ++++++ $k ++++++ $j ++++++ $j ++++++ $j ++++++ $ ++++++ $k"
	array set b1 [GNS_get_property 1 [lindex $pid_sanko_list $j]]
	array set a [GNS_get_property 0 [lindex $pid_list $j]]
	array set dt [GNS_get_distance 0 property $b(ID) 1 property $b1(ID)]
	set m 0
	set num 0
	set ele1 [GNS_get_eid_list 1 pid $b1(ID)]
	set num1 [llength $ele1]
	puts "so luong element cua 1 PID $b1(ID) la : $num1"
	set he_so_ele 0.5
	set he_so_khoang_cach_ido 2
	set he_so_khoang_cach_offset 12
	set he_so_ele1 0.94
	GNS_exe_command "era slo 1"
	GNS_exe_command "era pid $a(ID)"
	GNS_exe_command "era swap"
	array set phamvi1 [GNS_get_model_size 0 active]
#	puts "1 PID $b1(ID) : $phamvi1(MINX) $phamvi1(MINY) $phamvi1(MINZ) $phamvi1(MAXX) $phamvi1(MAXY) $phamvi1(MAXZ)"
	GNS_exe_command "add slo 1"
	GNS_exe_command "add all"
#	if {($dt(DT) ==0 ) && $num1 >= [expr $num*$he_so_ele1] && $num >= [expr $num1*$he_so_ele1]  } {
#set pid_sanko_list [ lreplace $pid_sanko(PIDS) $j $j]
#}
	if {abs([expr $phamvi(MINX)-$phamvi1(MINX)])<=12 && abs([expr $phamvi(MINY)+$phamvi1(MAXY)])<=12 && abs([expr $phamvi(MINZ)-$phamvi1(MINZ)])<=12 && abs([expr $phamvi(MAXX)-$phamvi1(MAXX)])<=12 && abs([expr $phamvi(MAXY)+$phamvi1(MINY)])<=12 && abs([expr $phamvi(MAXZ)-$phamvi1(MAXZ)])<=12  } {
		set num 1
	}
	if {$num == 1} {
			GNS_exe_command {
				add all
				col bac white
				vie res
				vie xro -90.000000
				vie yro 45.000000
				vie xro 30.000000
				vie cen
				opt tit off
	}
 # lam trong suot de hien vi tri
			GNS_exe_command {s[1]:slo swi off}
				GNS_exe_command "era pid $b(ID)"
				GNS_exe_command "era pid $a(ID)"
				GNS_exe_command {
				s[1]:slo swi on
				s[0]:slo swi off
				}
				GNS_exe_command "era pid $b1(ID)"
				GNS_exe_command "era pid $a1(ID)"
				GNS_exe_command {s[0]:slo swi on}
				GNS_exe_command {
				era spc all
				era rbe all
				era bar all
				era for all
				col pid gray act
				sty pid sho act
				col mtt 0.1 act
				era swa
				col pid red act
				add all
				col over black
				era pid 123
				era pid 1000000
				}
# vao khu vuc powerpooint				
			GNS_exe_command {s[1]:slo swi off}
			GNS_exe_command {
				s[1]:slo swi on
				s[0]:slo swi off
			}
			GNS_exe_command {s[0]:slo swi on}
			GNS_exe_command {
				v[new]p[new]:pre sho
			}
# chup tranh			
			GNS_exe_command {
			v[2]:pre add pag
			v[1]:vie cen
			v[2]:xcm vie wor
			v[2]:xcm pos 620 0
			v[2]:xcm siz 600 400
			v[2]:vie swi on
			v[2]:xcm pop
			v[2]:xcm vie max
			v[2]:xcm pos 0 0
			v[2]:xcm siz 1751 673
			v[1]:xcm pop
			v[2]:xcm vie max
			v[2]:xcm vie max
			v[2]:xcm vie kto off
			v[2]:xcm pop
			v[2]:vie swi on
			v[2]:pre add obj imt 1
			v[1]:vie swi on
			v[1]:xcm pop
			v[2]:xcm pop
			v[2]:vie swi on
			p[1]:pre sel gro 1
			v[2]:pre set pos 0.000210084 0.56211
			v[2]:pre set siz 0.400000 0.3774
            v[2]:pre set pos 0.00727892 0.608444
			p["Presentation"]:pre set fra all stp 0
            p["Presentation"]:pre set fra all wid 1.500000
			v[1]:vie swi on
			v[1]:xcm pop
			col pid res
			sty pid she all
			ide res
			add all
			}
			
			GNS_exe_command {s[1]:slo swi off}
			GNS_exe_command "era pid $b(ID)"
			GNS_exe_command "era pid $a(ID)"
			GNS_exe_command {
				s[1]:slo swi on
				s[0]:slo swi off
			}
			#GNS_exe_command "era pid $b1(ID)"
			GNS_exe_command {s[0]:slo swi on}
			GNS_exe_command {
				era swa
			}
			GNS_exe_command {s[1]:slo swi off}
			GNS_exe_command "txt pid add $b(ID) PID: $b(ID) T: $b(THICK)"
			GNS_exe_command "txt pid add $a(ID) PID: $a(ID) T: $a(THICK)"
			GNS_exe_command {
				col bac white
				vie res
				vie xro -90.000000
				vie yro 45.000000
				vie xro 30.000000
				vie cen
				vie sca 0.7
				 }
# chup bu-hin thu nhat
			GNS_exe_command {
			opt fs2 35
			v[1]:vie cen
			v[2]:vie swi on
			v[2]:xcm pop
			v[2]:pre add obj imt 1
			v[1]:vie swi on
			v[1]:xcm pop
			v[2]:xcm pop
			v[2]:vie swi on
			v[2]:vie ref
			p[1]:pre sel gro 2
			v[2]:pre set pos 0.000210084 0.56211
			v[2]:pre set siz 0.5000 0.4029
            v[2]:pre set pos 0.518773 0.00372348
			p["Presentation"]:pre set fra all stp 0
            p["Presentation"]:pre set fra all wid 1.500000
			v[1]:vie swi on
			v[1]:xcm pop
			exp slo 0 0 0 1 mod
			v[1]:vie cen
			v[1]:add all
			v[1]:vie cen
			ide res
			txt del all
			s[all][std]:slo col on
			}
#chup bu-hin thu 2
			GNS_exe_command {
				txt del all
				s[1]:slo swi on
				era all
			}
			GNS_exe_command {
				s[1]:slo swi on
				s[0]:slo swi off
				add all
			}
			GNS_exe_command "era pid $b1(ID)"
			GNS_exe_command "era pid $a1(ID)"
			GNS_exe_command "era swa"
			GNS_exe_command {
				col bac white
				vie res
				vie xro -90.000000
				vie yro 45.000000
				vie xro 30.000000
				vie cen
				vie sca 0.7
				 }
			GNS_exe_command {
				s[1]:slo swi on
				s[0]:slo swi off
			}
			GNS_exe_command "txt pid add $b1(ID) PID: $b1(ID) T: $b1(THICK)"
			GNS_exe_command "txt pid add $a1(ID) PID: $a1(ID) T: $a1(THICK)"
			GNS_exe_command {
			opt fs2 35
			v[1]:vie cen
			v[2]:vie swi on
			v[2]:xcm pop
			v[2]:pre add obj imt 1
			v[1]:vie swi on
			v[1]:xcm pop
			v[2]:xcm pop
			v[2]:vie swi on
			v[2]:vie ref
			p[1]:pre sel gro 3
			v[2]:pre set pos 0.000210084 0.56211
			v[2]:pre set siz 0.5000 0.4029
            v[2]:pre set pos 0.00406734 0.00372348
			p["Presentation"]:pre set fra all stp 0
            p["Presentation"]:pre set fra all wid 1.500000
			}
			GNS_exe_command {p[1]:pre set fon fam "Arial Unicode MS"}
			GNS_exe_command "pre add txt –â‚¢‡‚í‚¹“à—eF"
			GNS_exe_command "pre edi txt 5"
			GNS_exe_command "pre add tel 2 8"
			GNS_exe_command "pre set str F•t‚«•”•i‚Ì”ÂŒú‚ªˆá‚Á‚Ä‚¢‚Ü‚·B"
			GNS_exe_command "pre add tel 3 16"
			GNS_exe_command "pre set str ‚Ç‚ê‚ª³‰ð‚Å‚·‚©B"
			GNS_exe_command "pre add tel 4 9"
			GNS_exe_command "pre set str ‚²‰ñ“šF"
			GNS_exe_command "pre sel tel 5"
			GNS_exe_command "pre set col for 1 0 0"
			GNS_exe_command "pre sel tel 1-4"
            GNS_exe_command "pre set fon siz 20"
			GNS_exe_command "pre sel txt 5"
			GNS_exe_command "pre set pos 0.502675 0.71641"
			GNS_exe_command "pre set fra all stp 0"
			GNS_exe_command "pre sel txt 5"
			GNS_exe_command "pre set fra all stp 5"
			GNS_exe_command "pre des all"
			GNS_exe_command {
				v["pView"]:!pre des all
				v["pView"]:!pre add rec 0.494226 0.70098 0.377598 0.199346
				v["pView"]:vie refA
			}
			GNS_exe_command {
				v[1]:vie swi on
				v[1]:xcm pop
				exp slo 0 0 0 1 mod
				v[1]:vie cen
				v[1]:add all
				v[1]:vie cen
				ide res
				txt del all
				s[all][std]:slo col on
			}
			GNS_exe_command {
				s[1]:slo swi on
				s[0]:slo swi on
				add all
			}
			set pid_list [ lreplace $pid_list $j $j]
			set pid_sanko_list [ lreplace $pid_sanko_list $j $j]
# loai bo nhung thang bi trung
break
}
}
	if {$num == 0} {
	GNS_exe_command {
 add all
 col bac white
 vie res
vie xro -90.000000
vie yro 45.000000
vie xro 30.000000
vie cen
opt tit off
 }
 # lam trong suot de hien vi tri

 GNS_exe_command {s[1]:slo swi off}
				GNS_exe_command "era pid $b(ID)"
				GNS_exe_command {
				s[1]:slo swi on
				s[0]:slo swi off
				}
				GNS_exe_command "era pid $a1(ID)"
				GNS_exe_command {s[0]:slo swi on}
				GNS_exe_command {
				era spc all
				era rbe all
				era bar all
				era for all
				col pid gray act
				sty pid sho act
				col mtt 0.1 act
				era swa
				col pid red act
				add all
				col over black
				era pid 123
				era pid 1000000
				}
# vao khu vuc powerpooint				
				GNS_exe_command {s[1]:slo swi off}
			GNS_exe_command {
			s[1]:slo swi on
			s[0]:slo swi off
			}
			GNS_exe_command {s[0]:slo swi on}
			GNS_exe_command {
			v[new]p[new]:pre sho
			}
# chup tranh			
			GNS_exe_command {
			v[2]:pre add pag
			v[1]:vie cen
			v[2]:xcm vie wor
			v[2]:xcm pos 620 0
			v[2]:xcm siz 600 400
			v[2]:vie swi on
			v[2]:xcm pop
			v[2]:xcm vie max
			v[2]:xcm pos 0 0
			v[2]:xcm siz 1751 673
			v[1]:xcm pop
			v[2]:xcm vie max
			v[2]:xcm vie max
			v[2]:xcm vie kto off
			v[2]:xcm pop
			v[2]:vie swi on
			v[2]:pre add obj imt 1
			v[1]:vie swi on
			v[1]:xcm pop
			v[2]:xcm pop
			v[2]:vie swi on
			p[1]:pre sel gro 1
			v[2]:pre set pos 0.000210084 0.56211
			v[2]:pre set siz 0.400000 0.3774
            v[2]:pre set pos 0.00727892 0.608444
			p["Presentation"]:pre set fra all stp 0
            p["Presentation"]:pre set fra all wid 1.500000
			v[1]:vie swi on
			v[1]:xcm pop
			col pid res
			sty pid she all
			ide res
			add all
			}
			
			GNS_exe_command {s[1]:slo swi off}
			GNS_exe_command "era pid $b(ID)"
			GNS_exe_command {
			s[1]:slo swi on
			s[0]:slo swi off
			}
			#GNS_exe_command "era pid $b1(ID)"
			GNS_exe_command {s[0]:slo swi on}
			GNS_exe_command {
			era swa
			}
			GNS_exe_command {s[1]:slo swi off}
			GNS_exe_command "txt scr add 0.1 0 BASE--PID: $b(ID) T: $b(THICK)"
			GNS_exe_command {
				opt fs2 60
				col bac white
				vie res
				vie xro -90.000000
				vie yro 45.000000
				vie xro 30.000000
				vie cen
				 }
# chup bu-hin thu nhat
			GNS_exe_command {
			opt fs2 50
			v[1]:vie cen
			v[2]:vie swi on
			v[2]:xcm pop
			v[2]:pre add obj imt 1
			v[1]:vie swi on
			v[1]:xcm pop
			v[2]:xcm pop
			v[2]:vie swi on
			v[2]:vie ref
			p[1]:pre sel gro 2
			v[2]:pre set pos 0.000210084 0.56211
			v[2]:pre set siz 0.5000 0.4029
            v[2]:pre set pos 0.518773 0.00372348
			p["Presentation"]:pre set fra all stp 0
            p["Presentation"]:pre set fra all wid 1.500000
			v[1]:vie swi on
			v[1]:xcm pop
			exp slo 0 0 0 1 mod
			v[1]:vie cen
			v[1]:add all
			v[1]:vie cen
			ide res
			txt del all
			s[all][std]:slo col on
			}
#chup bu-hin thu 2
			GNS_exe_command {
			txt del all
			s[1]:slo swi on
			era all
			}
			GNS_exe_command {
			s[1]:slo swi on
			s[0]:slo swi off
			add all
			}
			GNS_exe_command "era pid $a1(ID)"
			GNS_exe_command "era swa"
			GNS_exe_command {
				col bac white
				vie res
				vie xro -90.000000
				vie yro 45.000000
				vie xro 30.000000
				vie cen
				 }
			GNS_exe_command {
			s[1]:slo swi on
			s[0]:slo swi off
			}
			GNS_exe_command "txt scr add 0.1 0 SANKO--PID: $a1(ID) T: $a1(THICK)"
			GNS_exe_command {
			opt fs2 30
			v[1]:vie cen
			v[2]:vie swi on
			v[2]:xcm pop
			v[2]:pre add obj imt 1
			v[1]:vie swi on
			v[1]:xcm pop
			v[2]:xcm pop
			v[2]:vie swi on
			v[2]:vie ref
			p[1]:pre sel gro 3
			v[2]:pre set pos 0.000210084 0.56211
			v[2]:pre set siz 0.5000 0.4029
            v[2]:pre set pos 0.00406734 0.00372348
			p["Presentation"]:pre set fra all stp 0
            p["Presentation"]:pre set fra all wid 1.500000
			}
			GNS_exe_command {p[1]:pre set fon fam "Arial Unicode MS"}
			GNS_exe_command "pre add txt –â‚¢‡‚í‚¹“à—eF"
			GNS_exe_command "pre edi txt 3"
			GNS_exe_command "pre add tel 2 8"
			GNS_exe_command "pre set str F•t‚«•”•i‚Ì”ÂŒú‚ªˆá‚Á‚Ä‚¢‚Ü‚·B"
			GNS_exe_command "pre add tel 3 16"
			GNS_exe_command "pre set str ‚Ç‚ê‚ª³‰ð‚Å‚·‚©B"
			GNS_exe_command "pre add tel 4 9"
			GNS_exe_command "pre set str ‚²‰ñ“šF"
			GNS_exe_command "pre sel tel 4"
			GNS_exe_command "pre set col for 1 0 0"
			GNS_exe_command "pre sel tel 1-4"
            GNS_exe_command "pre set fon siz 20"
			GNS_exe_command "pre sel txt 3"
			GNS_exe_command "pre set pos 0.502675 0.71641"
			GNS_exe_command "pre set fra all stp 0"
			GNS_exe_command "pre sel txt 3"
			GNS_exe_command "pre set fra all stp 5"
			GNS_exe_command "pre des all"
			GNS_exe_command {
			v["pView"]:!pre des all
			v["pView"]:!pre add rec 0.494226 0.70098 0.377598 0.199346
			v["pView"]:vie ref
			}
			GNS_exe_command {
			 v[1]:vie swi on
			v[1]:xcm pop
			exp slo 0 0 0 1 mod
			v[1]:vie cen
			v[1]:add all
			v[1]:vie cen
			ide res
			txt del all
			s[all][std]:slo col on
			}
			GNS_exe_command {
			s[1]:slo swi on
			s[0]:slo swi on
			add all
			}
}
}
GNS_exe_command {
v["pView"]:vie swi on
v["pView"]:xcm pop
}
set geopath [ GNS_get_system_var 0 GEOFILEPATH ]
GNS_exe_command "pre wri ppx 1-10000 '$geopath\PID-THICK.pptx' 2007"
