
# GK28 tamhv knt20993
#thiet lap luc tinh toan
#xuat file master va cac hang muc tinh toan 
#chay CDH
#chuan bi file tinh toan (.dat)
#pham vi su dung SEI, DOU, TA
# ----------------------------------------------
# day 24/02/2024 sua lai name out_bo "_Master" trong ten output
# day 24/02/2024 sua lai logic tinh truc cua bolt => Ly do G01 nhan dien truc X thay vi Z
# ---------------------------------------------------------------------
 proc main {} {
	set star "Start"
	set end "END"
	log $star
	##### phan code cu dung de xu ly duoc dat o day     



namespace eval ::NTV {} {}

#thiet lap giao dien
proc ::NTV::main_GUI {} {
	global glo ; global filemodel; global outputfolder; global supportfolder , base
	set base .tool1;
	toplevel $base;
	::hwt::KeepOnTop $base
	wm attribute $base -toolwindow 0
	wm title $base "è§£æžæ¡ä»¶è¨­å®šã¨è¨ˆç®—æº–å‚™è‡ªå‹•åŒ–";
	wm geometry $base 450x100;
	#Create a master frame
	set master_frame [frame $base.master_frame];
	pack $master_frame -side top -anchor nw -padx 7 -pady 7 -expand 1 -fill both;

	set gui(f1) [frame $master_frame.f1]
	pack $gui(f1) -side top -padx 2 -pady 2 -expand 0 -fill x
	
		# set gui(f1_model) [frame $gui(f1).f1_model]
		# pack $gui(f1_model) -side top -padx 2 -pady 2 -expand 0 -fill x
		
			# set gui(ent_model) [entry $gui(f1_model).ent_model -textvariable filemodel]
			# pack $gui(ent_model) -side left -padx 0 -pady 0 -expand 1 -fill x 
		
			# set gui(but_model) [button $gui(f1_model).but_model -text "File Mater" -width 12 -command "::NTV::open_file filemodel" ]
			# pack $gui(but_model) -side left -padx 0 -pady 0 -fill y
	
		set gui(f1_open_model) [frame $gui(f1).f1_open_model]
		pack $gui(f1_open_model) -side top -padx 2 -pady 2 -expand 0 -fill x
		
			set gui(ent_open_model) [entry $gui(f1_open_model).ent_open_model -textvariable glo(path_fileinput)]
			pack $gui(ent_open_model) -side left -padx 0 -pady 0 -expand 1 -fill x 
		
			set gui(but_open_model) [button $gui(f1_open_model).but_open_model -text "File Excel" -width 12 -command "::NTV::open_file fileinput" ]
			pack $gui(but_open_model) -side left -padx 0 -pady 0 -fill y
			
		# set gui(f1_output_folder) [frame $gui(f1).f1_output_folder]
		# pack $gui(f1_output_folder) -side top -padx 2 -pady 2 -expand 0 -fill x
		
			# set gui(ent_output_folder) [entry $gui(f1_output_folder).ent_output_folder -textvariable outputfolder]
			# pack $gui(ent_output_folder) -side left -padx 0 -pady 0 -expand 1 -fill x 
		
			# set gui(but_output_folder) [button $gui(f1_output_folder).but_output_folder -text "OutPut Folder" -width 12 -command "::NTV::open_file outputfolder" ]
			# pack $gui(but_output_folder) -side left -padx 0 -pady 0 -fill y
			
		# set gui(f1_support_folder) [frame $gui(f1).f1_support_folder]
		# pack $gui(f1_support_folder) -side top -padx 2 -pady 2 -expand 0 -fill x
		
			# set gui(ent_support_folder) [entry $gui(f1_support_folder).ent_support_folder -textvariable supportfolder]
			# pack $gui(ent_support_folder) -side left -padx 0 -pady 0 -expand 1 -fill x 
		
			# set gui(but_support_folder) [button $gui(f1_support_folder).but_support_folder -text "Support Folder" -width 12 -command "::NTV::open_file supportfolder" ]
			# pack $gui(but_support_folder) -side left -padx 0 -pady 0 -fill y
			
	
  set buttons_frame [frame $master_frame.buttons_frame];
   pack $buttons_frame -side top -anchor nw -expand 1 -fill both;

      set accept_button [button $buttons_frame.accept \
         -text "Accept" \
         -relief raised \
         -command "Run"\
		 -height 2\
		 -width 15];

      set cancel_button [button $buttons_frame.cancel \
         -text "Cancel" \
         -relief raised \
         -command "destroy $base"\
		 -height 2\
		 -width 15];
      pack $accept_button -side left -anchor se -padx 4;
	  pack $cancel_button -side right -anchor se ;	  
}

#gan bien mo file
proc ::NTV::open_file {mode} {
	variable gui; variable arr; global glo ; global filemodel; global outputfolder; global supportfolder
	if {$mode =="outputfolder" || $mode == "supportfolder"} {
		set glo(path_$mode) [tk_chooseDirectory] 
	} else {
		set glo(path_$mode) [tk_getOpenFile]
	}
}

#doc thong tin sheet input excel
proc read_input {} {
	puts "Run read_input"
	puts "------------------"
	variable gui; global glo ; global filemodel; global outputfolder; global supportfolder ; global filemodel; global outputfolder; global supportfolder
	variable base
	# set input $glo(path_fileinput)
	set excel_file $glo(path_fileinput)
	package require twapi
	set excel [::twapi::comobj Excel.Application]
	$excel DisplayAlerts [expr 0]
	set workbooks [$excel Workbooks]
	$workbooks Open "$excel_file"
	set workbook [$workbooks Item 1]
	set sheets [$workbook Sheets]
	set sheet [$sheets Item 3]
	set cells [$sheet Cells]
	$excel Run re_namepath
	set filemodel	[[$sheet range D10] Value]
	set outputfolder [[$sheet range D18] Value]
	set supportfolder [[$sheet range D12] Value]
	$workbook Save
	$excel Quit
	$cells -destroy
	$sheet -destroy
	$sheets -destroy
	$workbook -destroy
	$workbooks -destroy
	$excel -destroy
	unset excel
}

#main modul
proc Run {} { 
	variable gui; global glo ; global filemodel; global outputfolder; global supportfolder
	variable base
	set input [read_input]
	set read_excel [read_force]
	set force [lindex $read_excel 0]
	set force_pres [lindex $read_excel 1]
	set spc_node [lindex $read_excel 2]
	set spc_range [lindex $read_excel 3]
	set gotail_b09 [lindex $read_excel 4]
	set e77 [lindex $read_excel 5]
	set moment [lindex $read_excel 6]
	set node_globals [lindex $read_excel 7]
	set id_b09 [lindex $read_excel 8]
	set cdh_data [lindex $read_excel 9]
	set assem_all [read_assem]
	set assem [lindex $assem_all 0]
	set mats [lindex $assem_all 1]
	create_SPC_B09 $gotail_b09 $id_b09
	create_force $force
	create_moment $moment
	creat_force_comp $force_pres
	create_spc $spc_node
	create_spc_range $spc_range
	create_spc_e77 $e77
	############rename_force_sei $assem
	export_master
	export_data_sei $assem $mats
	export_data_dou $assem $mats
	set id_comp_keep [hm_latestentityid comps]
	set id_loadcol_keep [hm_latestentityid loadcols]
	boruto_add $assem
	beam_add $assem
	add_node_local $assem
	exprot_plot $assem
	node_global_dat $node_globals
	set list_truc_beam [truc_beam $assem]
	run_VBA_beam $list_truc_beam  
	set list_truc_botl [truc_botl $assem]
	run_VBA_botl $list_truc_botl
	run_VBA_node $assem
	set id_comp_remove [hm_latestentityid comps]
	set id_loadcol_remove [hm_latestentityid loadcols]
	# for {set i [expr $id_comp_keep + 1]} {$i < $id_comp_remove + 1} {incr i} {
		# *createmark components 1 $i
		# *deletemark components 1
	# }
	copy_vip 
	copy_vip_TA $assem
	run_cdh $cdh_data
	cdh_TA $assem $cdh_data
	delete_trash $assem
	copy_hexa_rb3 $assem
	dat_dou $assem
	dat_sei $assem

	tk_messageBox -message "Complete"
	destroy $base
}

#lam file tinh toan (.dat) cho SEI
proc dat_sei {assem} {
	puts "Run dat_sei"
	puts "------------------"
	variable gui; global glo ; global filemodel; global outputfolder; global supportfolder
	set support_folder $supportfolder
	set output_folder $outputfolder
	set model $filemodel
	set spli_model [split $model "/"]
	set l [llength $spli_model]
	set name_master [lindex $spli_model [expr $l - 1]]
	set name_tile [string map "0BI_Master.nas 0" $name_master]
	set link_master "$output_folder/00_Model"
	foreach ass $assem {
		if {[lindex $ass 0] == "SEI" || [lindex $ass 0] == "TA"} {
			if {[lindex $ass 1] == ""} {
				continue
			}		
			set bango [lindex $ass 1]
			set name [lindex $ass 2]
			set spc_ids [lindex $ass 6]
			set force_ids [lindex $ass 7]
			set set_list [lindex $ass 8]
			set dat_data [lindex $ass 10]
			set disp_mode [lindex $ass 9]
			set link_folder "$output_folder/$name"
			set include ""
			set files [glob -directory $link_folder -- *]
			foreach file $files {
				set len_file [string length $file]
				if {[string first ".hexa" $file] != -1 || [string first ".rbe3" $file] != -1 
					|| [string first ".set" $file] != -1 || [string first ".uset" $file] != -1
					|| [string first ".nas" $file] != -1 && [string range $file [expr $len_file - 8] $len_file]!= "plot.nas"} {
					set spli_file [split $file "/"]
					set len_file [llength $spli_file]
					set name_inclu [lindex $spli_file [expr $len_file - 1]]
					append include "INCLUDE '$name_inclu'"
					append include "\n"
				}
			}
			append include "ENDDATA"
			
			if {$disp_mode=="ã€‡" && $dat_data == ""} {
				set file_dat_input1 "$support_folder/DAT-DATA/$bango-Disp.dat"
				set dat_input1 "$file_dat_input1"
				set readfile1 [open $dat_input1 r]
				set lines1 [read $readfile1]
				close $readfile1
				set list_line1 [split $lines1 "\n"]
				set leng_all [llength $list_line1]
				set title_incl [lsearch $list_line1 "INCLUDE*"]
				if {$title_incl != -1} {
					set list_line1 [lreplace $list_line1 $title_incl $leng_all]
					set lines1 [join $list_line1 "\n"]
				}
				append lines1 "\n"
				append lines1 $include
				set list_line1 [split $lines1 "\n"]
					# set title_check1 [lsearch $list_line1 "TITLE =*"]
					# set title_line1 "TITLE = $name"
					# set list_line1 [lreplace $list_line1 $title_check1 $title_check1 $title_line1]
				set list_line1 [lremove -all $list_line1 [list {}]]
				set ouput_dat [string map "Master.nas $bango" $name_master]
				set new_file_dat1 "$output_folder/$name/$ouput_dat-Disp.dat"
				set writefile1 [open $new_file_dat1 w]
				puts $writefile1 $lines1
				close $writefile1
					
				set file_dat_input2 "$support_folder/DAT-DATA/$bango-Mode.dat"
				set dat_input2 "$file_dat_input2"
				set readfile2 [open $dat_input2 r]
				set lines2 [read $readfile2]
				close $readfile2
				set list_line2 [split $lines2 "\n"]
				set leng_all [llength $list_line2]
				set title_incl2 [lsearch $list_line2 "INCLUDE*"]
				if {$title_incl2 != -1} {
					set list_line2 [lreplace $list_line2 $title_incl2 $leng_all]
					set lines2 [join $list_line2 "\n"]
				}
				append lines2 "\n"
				append lines2 $include

				set list_line2 [split $lines2 "\n"]
					# set title_check2 [lsearch $list_line2 "TITLE =*"]
					# set title_line2 "TITLE = $name"
					# set list_line2 [lreplace $list_line2 $title_check2 $title_check2 $title_line2]
				set list_line2 [lremove -all $list_line2 [list {}]]
				set ouput_dat [string map "Master.nas $bango" $name_master]
				set new_file_dat2 "$output_folder/$name/$ouput_dat-Mode.dat" 
				set writefile2 [open $new_file_dat2 w]
				puts $writefile2 $lines2
				close $writefile2
					
				file mkdir "$output_folder/$name/Mode"
					# puts "$output_folder/$name/Mode"
				file mkdir "$output_folder/$name/Disp"
				file copy "$output_folder/$name/$ouput_dat-Mode.dat" "$output_folder/$name/Mode/$ouput_dat-Mode.dat"
				file copy "$output_folder/$name/$ouput_dat-Disp.dat" "$output_folder/$name/Disp/$ouput_dat-Disp.dat"
				file delete -force -- "$output_folder/$name/$ouput_dat-Mode.dat"
				file delete -force -- "$output_folder/$name/$ouput_dat-Disp.dat"
				foreach file $files { 
					set len_file [string length $file]
					if {[string first ".hexa" $file] != -1 || [string first ".rbe3" $file] != -1 
						|| [string first ".set" $file] != -1 || [string first ".uset" $file] != -1
						|| [string first ".nas" $file] != -1} {
						set spli_file [split $file "/"]
						set len_file [llength $spli_file]
						set name_inclu [lindex $spli_file [expr $len_file - 1]]
						file copy "$output_folder/$name/$name_inclu" "$output_folder/$name/Mode/$name_inclu"
						file copy "$output_folder/$name/$name_inclu" "$output_folder/$name/Disp/$name_inclu"
							# puts "$output_folder/$name/$name_inclu"
						file delete -force -- "$output_folder/$name/$name_inclu"
					}
				}
			}
			
			if {$dat_data=="ã€‡" && $disp_mode==""} {
				set file_dat_input1 "$support_folder/DAT-DATA/$bango.dat"
				set dat_input1 "$file_dat_input1"
				set readfile1 [open $dat_input1 r]
				set lines1 [read $readfile1]
				close $readfile1
				set list_line1 [split $lines1 "\n"]
				set leng_all [llength $list_line1]
				set title_incl [lsearch $list_line1 "INCLUDE*"]
				if {$title_incl != -1} {
					set list_line1 [lreplace $list_line1 $title_incl $leng_all]
					set lines1 [join $list_line1 "\n"]
				}
				append lines1 "\n"
				append lines1 $include
				set list_line1 [split $lines1 "\n"]
					# set title_check1 [lsearch $list_line1 "TITLE =*"]
					# set title_line1 "TITLE = $name"
					# set list_line1 [lreplace $list_line1 $title_check1 $title_check1 $title_line1]
				set list_line1 [lremove -all $list_line1 [list {}]]
				set ouput_dat [string map "Master.nas $bango" $name_master]
				set new_file_dat1 "$output_folder/$name/$ouput_dat.dat"
				set writefile1 [open $new_file_dat1 w]
				puts $writefile1 $lines1
				close $writefile1
			}
			
			if {$dat_data=="" && $disp_mode==""} {
				set file_dat_input "$support_folder/sei.dat"
				set dat_input "$file_dat_input"
				set readfile [open $dat_input r]
				set lines [read $readfile]
				close $readfile
				append lines $include
					
				set list_line [split $lines "\n"]
				set title_check [lsearch $list_line "TITLE =*"]
				set name [lindex $ass 2]
				set title_line "TITLE = $name_tile"
				set list_line [lreplace $list_line $title_check $title_check $title_line]
					
				set data_force ""
				set data_force1 ""
				set data_force2 ""
				if {$set_list != ""} {
					for {set m 1} {$m <= [llength $set_list]} {incr m} {
						set x [lindex $set_list [expr $m-1]]
						if {[string is double -strict $x] == 1} {
							set x [format "%.0f" $x]
						}
						set set_id "SET $m = $x"
						append data_force $set_id
						append data_force "\n"
					}
				}
				set subcase 1
				eval *createmark loadcols 1 $force_ids 
				set sum_subcase [hm_getmark loadcols 1]
				for {set i 0} {$i <= [expr [llength $force_ids] -1]} {incr i} {
					eval *createmark loadcols 1 [lindex $force_ids $i] 
					set a [hm_getmark loadcols 1]
					foreach load $a {
						set line1 "$"
						set line2 "SUBCASE $subcase"
						if {[llength $spc_ids] == 1} {
							set spc [lindex $spc_ids 0]
						} else {
							set spc [lindex $spc_ids $i]
						}
						eval *createmark loadcols 1 $spc 
						set spc [hm_getmark loadcols 1]
						set line3 " SPC = $spc"
						set line4 " LOAD = $load"
						set subcase_puch [expr $subcase + [llength $sum_subcase]]
						set line5 "$"
						set line6 "SUBCASE $subcase_puch"
							# if {[llength $spc_ids] == 1} {
								# set spc [lindex $spc_ids 0]
							# } else {
								# set spc [lindex $spc_ids $i]
							# }
						set line7 " SPC = $spc" 
						set line8 " LOAD = $load"
						set set_id [expr $i + 1]
						set line9 "DISP(PUNCH) = $set_id"
						set subcase [expr $subcase +1]
							
						append data_force1 $line1
						append data_force1 "\n"
						append data_force1 $line2
						append data_force1 "\n"
						append data_force1 $line3
						append data_force1 "\n"
						append data_force1 $line4	
						append data_force1 "\n"
							
						if {$set_list != ""} {			
							append data_force2 $line5
							append data_force2 "\n"
							append data_force2 $line6
							append data_force2 "\n"
							append data_force2 $line7
							append data_force2 "\n"
							append data_force2 $line8	
							append data_force2 "\n"
							append data_force2 $line9	
							append data_force2 "\n"
						}
					}
				}
				append data_force $data_force1
				append data_force $data_force2
				set a [string length $data_force]
				set data_force [string replace $data_force [expr $a-1] [expr $a -1] ""]
				set bulk_check [lsearch $list_line "BEGIN BULK"]
				set force_posion [expr $bulk_check - 1]
				set list_line [linsert $list_line $force_posion $data_force]
				set ouput_dat [string map "Master.nas $bango" $name_master]
				set new_file_dat "$output_folder/$name/$ouput_dat.dat"
				set writefile [open $new_file_dat w]
				puts $writefile [join $list_line "\n"]
				close $writefile
			}
		}
	}
}

#xoa cac file rac khi chay CDH xong
proc delete_trash {assem} {
	puts "Run delete_trash"
	puts "------------------"
	variable gui; global glo ; global filemodel; global outputfolder; global supportfolder
	set output_folder $outputfolder
	set output_master "$output_folder/00_Model"
	set files [glob -directory $output_master -- *]
	foreach file $files { 
		set len_file [string length $file]
		set del_name [string range $file [expr $len_file - 4] [expr $len_file - 1]]
		if {$del_name != ".dat" && $del_name != ".nas" && $del_name != "hexa" && $del_name != "rbe3"
			&& $del_name != ".set" && $del_name != "uset"} {
				file delete -force -- $file
		}
	}
	foreach ass $assem {
		if {[lindex $ass 0] == "TA"} {
			set name_folder [lindex $ass 2]
			if {$name_folder == ""} {
				break
			}
			set output_ta "$output_folder/$name_folder"
			set files_ta [glob -directory $output_ta -- *]
			foreach file $files_ta { 
				set len_file [string length $file]
				set del_name [string range $file [expr $len_file - 4] [expr $len_file - 1]]
				if {$del_name != ".dat" && $del_name != ".nas" && $del_name != "hexa" && $del_name != "rbe3"
					&& $del_name != ".set" && $del_name != "uset"} {
						file delete -force -- $file
				}
			}
		}
	}
}

#tu folder master da chay cdh, copy cac file hexa, rbe3 ve cac folder con, khong phai TA 
proc copy_hexa_rb3 {assem} {
	puts "Run copy_hexa_rb3"
	puts "------------------"
	variable gui; global glo ; global filemodel; global outputfolder; global supportfolder
	set output_folder $outputfolder
	set model $filemodel
	file mkdir "$output_folder/00_Model"
	set spli_model [split $model "/"]
	set l [llength $spli_model]
	set name_master [lindex $spli_model [expr $l - 1]]
	set link_master "$output_folder/00_Model"
	set files [glob -directory $link_master -- *]
	foreach ass $assem {
		set name_folder [lindex $ass 2]
		if {$name_folder!= "" && [lindex $ass 0] != "TA"} {
			foreach file $files {
				set spli_vip [split $file "/"]
				set len_vip [llength $spli_vip]
				set name_vip [lindex $len_vip [expr $len_vip - 1]]
				if {[string first ".hexa" $file] != -1 || [string first ".rbe3" $file] != -1
				|| [string first ".set" $file] != -1 || [string first ".uset" $file] != -1} {
					file copy $file "$output_folder/$name_folder/$name_vip"
				}
			}
		}
	}
}

#tien hanh chay CDH cho tung file TA
proc cdh_TA {assem cdh_data} {
	puts "Run cdh_TA"
	puts "------------------"
	variable gui; global glo ; global filemodel; global outputfolder; global supportfolder
	set output_folder $outputfolder
	set model $filemodel
	set spli_model [split $model "/"]
	set l [llength $spli_model]
	set name_master [lindex $spli_model [expr $l - 1]]
	set excel_file "D:/Analysis_Tool/NEW_IF/cdh/auto_cdh.xlsm"
	package require twapi
	set excel [::twapi::comobj Excel.Application]
	$excel DisplayAlerts [expr 0]
	set workbooks [$excel Workbooks]
	$workbooks Open "$excel_file"
	set workbook [$workbooks Item 1]
	set sheets [$workbook Sheets]
	set sheet [$sheets Item 1]
	set cells [$sheet Cells]
	foreach ass $assem {
		if {[lindex $ass 0] == "TA" && [lindex $ass 10] != ""} {
			set name [lindex $ass 2]
			set bango [lindex $ass 1]
			set master_check "Master"
			set name_output [string map "$master_check $bango" $name_master]
			$cells Item 1 A ""
			$cells Item 2 A "$output_folder/$name/$name_output"
			set fole_master "$output_folder/$name"
			set files [glob -directory $fole_master -- *]
			set gird 50000000
			set solid 50000000
			set rbe3 51000000
			set off 500
			foreach file $files { 
				if {[string first ".vip" $file] != -1 } {
					set len_file [string length $file]
					set cdh_name [string range $file [expr $len_file - 7] [expr $len_file - 5]]
					$cells Item 3 A $file
					$cells Item 4 A ""
					$cells Item 5 A ""
					$cells Item 6 A ""
					$cells Item 7 A ""
					$cells Item 8 A ""
					foreach cdh $cdh_data {
						set file_run [lindex $cdh 0]
						if {[string first $cdh_name $file_run] != -1} {
							set yung [lindex $cdh 1]
							$cells Item 8 A $yung
						} else {
							continue
						}
					}
					if {[string first "mas.vip" $file] == -1 && [string first "plug.vip" $file] == -1 
					&& [string first "rivet.vip" $file] == -1 && [string first "spot.vip" $file] == -1} {
						$cells Item 4 A $gird
						$cells Item 5 A $solid
						$cells Item 6 A $rbe3
						$cells Item 7 A $off
						set gird [expr $gird - 10000000]
						set solid [expr $solid - 10000000]
						set rbe3 [expr $rbe3 - 10000000]
						set off [expr $off-100]
					}
					$excel Run run_cdh
					after 5000
					set files_checks [glob -directory $fole_master -- *]
					foreach file_check $files_checks { 
						if {[string first ".mmSIsptFe.hexa" $file_check] != -1 || [string first ".mmSIsptFe.rbe3" $file_check] != -1} {
							set type_file [string range $file [expr $len_file-7] [expr $len_file - 5]]
							set file_hexa [string map "spt $type_file" $file_check]
							# Sua lai name cai file outpu 24022024
							set file_kmaster [string map "_Master. ." $file_hexa ]
							file rename $file_check $file_kmaster
						}
					}
				}
			}
		
		}
	} 
	
	$excel Quit
	$cells -destroy
	$sheet -destroy
	$sheets -destroy
	$workbook -destroy
	$workbooks -destroy
	$excel -destroy
	unset excel
}

#copy cac file Vip tuong ung voi tung Tamping ve chung folder output
proc copy_vip_TA {assem} {
	puts "Run copy_vip_TA"
	puts "------------------"
	variable gui; global glo ; global filemodel; global outputfolder; global supportfolder
	set output_folder $outputfolder
	set model $filemodel
	# set model "C:/Users/knt20993/Desktop/aaaaa/mater/L21C-ICE-US-DC-00-N000BI_Master.nas"
	set spli_model [split $model "/"]
	set l [llength $spli_model]
	set name_master [lindex $spli_model [expr $l - 1]]
	set len_name_master [string length $name_master]
	set len_model [string length $model]
	set folder_input [string replace $model [expr $len_model - $len_name_master - 1] $len_model ""]
	set folder_TA "$folder_input/TA"
	if {[file exists $folder_TA]==1} {
		set check_emty [glob -nocomplain "$folder_TA/*"]
		if {[llength $check_emty] != 0 } {
			set files_TAs [glob -directory $folder_TA -- *]
		# puts $files_TAs
			foreach ass $assem {
				if {[lindex $ass 0] == "TA"} {
					set bango [lindex $ass 1]
					set name [lindex $ass 2]
					set cdh_name [lindex $ass 11]
					set cdh_name [split $cdh_name "/"]
					foreach file $files_TAs {
						set spli_vip_ta [split $file "/"]
						set len_vip_ta [llength $spli_vip_ta]
						set name_vip_ta [lindex $spli_vip_ta [expr $len_vip_ta - 1]]
						if {[string first $cdh_name $name_vip_ta] != -1} {
							file copy $file "$output_folder/$name/$name_vip_ta"
						}
					}
				} 
			}
		}
	}
}

#Copy file VIP tu folder chua file master ve cung folder voi file master vua xuat ra
proc copy_vip {} {
	puts "Run copy_vip"
	puts "------------------"
	variable gui; global glo ; global filemodel; global outputfolder; global supportfolder
	set output_folder $outputfolder
	set model $filemodel
	# set model "C:/Users/knt20993/Desktop/aaaaa/mater/L21C-ICE-US-DC-00-N000BI_Master.nas"
	set spli_model [split $model "/"]
	set l [llength $spli_model]
	set name_master [lindex $spli_model [expr $l - 1]]
	set len_name_master [string length $name_master]
	set len_model [string length $model]
	set folder_input [string replace $model [expr $len_model - $len_name_master - 1] $len_model ""]
	set files [glob -directory $folder_input -- *]
	foreach file $files {
		if {[string first ".vip" $file] != -1 || [string first ".set" $file] != -1 || [string first ".uset" $file] != -1} {
			set spli_vip [split $file "/"]
			set len_vip [llength $spli_vip]
			set name_vip [lindex $spli_vip [expr $l - 1]]
			file copy $file "$output_folder/00_Model/$name_vip"
		}
	}
}

#chay CDH cho file master
proc run_cdh {cdh_data} {
	puts "Run run_cdh"
	puts "------------------"
	variable gui; global glo ; global filemodel; global outputfolder; global supportfolder
	set output_folder $outputfolder
	set model $filemodel
	set spli_model [split $model "/"]
	set l [llength $spli_model]
	set name_master [lindex $spli_model [expr $l - 1]]
	set excel_file "D:/Analysis_Tool/NEW_IF/cdh/auto_cdh.xlsm"
	package require twapi
	set excel [::twapi::comobj Excel.Application]
	$excel DisplayAlerts [expr 0]
	set workbooks [$excel Workbooks]
	$workbooks Open "$excel_file"
	set workbook [$workbooks Item 1]
	set sheets [$workbook Sheets]
	set sheet [$sheets Item 1]
	set cells [$sheet Cells]
	$cells Item 1 A ""
	$cells Item 2 A "$output_folder/00_Model/$name_master"
	set fole_master "$output_folder/00_Model"
	set files [glob -directory $fole_master -- *]
	set gird 50000000
	set solid 50000000
	set rbe3 51000000
	set off 500
	foreach file $files { 
		if {[string first ".vip" $file] != -1 } {
			set len_file [string length $file]
			set cdh_name [string range $file [expr $len_file - 7] [expr $len_file - 5]]
			$cells Item 3 A $file
			$cells Item 4 A ""
			$cells Item 5 A ""
			$cells Item 6 A ""
			$cells Item 7 A ""
			$cells Item 8 A ""
			foreach cdh $cdh_data {
				set file_run [lindex $cdh 0]
				if {[string first $cdh_name $file_run] != -1} {
					set yung [lindex $cdh 1]
					$cells Item 8 A $yung
				} else {
					continue
				}
			}
			if {[string first "mas.vip" $file] == -1 && [string first "plug.vip" $file] == -1 
			&& [string first "rivet.vip" $file] == -1 && [string first "spot.vip" $file] == -1} {
				$cells Item 4 A $gird
				$cells Item 5 A $solid
				$cells Item 6 A $rbe3
				$cells Item 7 A $off
				set gird [expr $gird - 10000000]
				set solid [expr $solid - 10000000]
				set rbe3 [expr $rbe3 - 10000000]
				set off [expr $off-100]
			}
			$excel Run run_cdh
			after 5000
			set files_checks [glob -directory $fole_master -- *]
			foreach file_check $files_checks { 
				if {[string first ".mmSIsptFe.hexa" $file_check] != -1 || [string first ".mmSIsptFe.rbe3" $file_check] != -1} {
					set type_file [string range $file [expr $len_file-7] [expr $len_file - 5]]
					set file_hexa [string map "spt $type_file" $file_check]
					# Sua lai name cai file outpu 24022024
					set file_kmaster [string map "_Master. ." $file_hexa ] 
					file rename $file_check $file_kmaster
				}
			}
		}
	}
	$excel Quit
	$cells -destroy
	$sheet -destroy
	$sheets -destroy
	$workbook -destroy
	$workbooks -destroy
	$excel -destroy
	unset excel
}

#xuat file master sau khi lam luc
proc export_master {} {
	puts "Run export_master"
	puts "------------------"
	variable gui; global glo ; global filemodel; global outputfolder; global supportfolder
	set output_folder $outputfolder
	set model $filemodel
	file mkdir "$output_folder/00_Model"
	set spli_model [split $model "/"]
	set l [llength $spli_model]
	set name_master [lindex $spli_model [expr $l - 1]]
	
	*retainmarkselections 0
	*createstringarray 4 "HM_REAL_VALUES_E_OPTION " "HM_NODEELEMS_SET_COMPRESS_SKIP " \
	"EXPORT_SYSTEM_LONGFORMAT " "HMBOMCOMMENTS_XML"
	hm_answernext yes
	set template [hm_info -appinfo SPECIFIEDPATH TEMPLATES_DIR]
	*feoutputwithdata "$template/feoutput/nastran/general" "$output_folder/00_Model/$name_master" 0 0 1 1 4
	
	hm_answernext yes
	*deletemodel 
	*feinputpreserveincludefiles 
	*createstringarray 12 "Nastran " "NastranMSC " "ANSA " "PATRAN " "SPC1_To_SPC " \
	"HM_READ_PCL_GRUPEE_COMMENTS " "EXPAND_IDS_FOR_FORMULA_SETS " "ASSIGNPROP_BYHMCOMMENTS" \
	"LOADCOLS_DISPLAY_SKIP " "VECTORCOLS_DISPLAY_SKIP " "SYSTCOLS_DISPLAY_SKIP " \
	"CONTACTSURF_DISPLAY_SKIP "
	*feinputwithdata2 "\#nastran\\nastran" "$output_folder/00_Model/$name_master" 0 0 0 0 0 1 12 1 0
}

proc loc_node_del {list_node x} {
	set node_del []
	for {set i 0} {$i < [expr [llength $list_node] - 1]} {incr i} {
		for {set j [expr $i +1]} {$j < [llength $list_node]} {incr j} {
			if {[lindex $list_node $i] != [lindex $list_node $j]} {
				set node1 [lindex $list_node $i]
				set node2 [lindex $list_node $j]
				set dis_check [hm_getdistance nodes $node1 $node2 0]
				set rx [lindex $dis_check 1]
				set ry [lindex $dis_check 2]
				set rz [lindex $dis_check 3]
				set r [lindex $dis_check 0]
				if {[expr abs($rx)] < 10 && [expr abs($rz)] < 1 && [expr abs($ry)] < 1} {
				# && [expr abs($rz)] < 1 && [expr abs($ry)] < 1} {
					set x1 [hm_getvalue nodes id=$node1 dataname=x]
					set x2 [hm_getvalue nodes id=$node2 dataname=x]
					if {$x1 < $x && $x2 <$x} {
						puts "node_trai"
						set k [expr $x -100]
						if {[expr abs($x1-$k)] >= [expr abs($x2-$k)]} {
							lappend node_del $node1
						} else {
							lappend node_del $node2
						}
					}
					if {$x1 > $x && $x2 >$x} {
						puts "node_phai"
						set k [expr $x +100]
						if {[expr abs($x1-$k)] >= [expr abs($x2-$k)]} {
							lappend node_del $node1
						} else { 
							lappend node_del $node2
						}
					}
				}
			}
		}
	}
	puts "node_dell"
	set node_del [lsort -unique $node_del]
	puts [llength $node_del]
	puts [llength $list_node]
	foreach node $node_del {
		set list_node [lremove $list_node $node]
	}
	puts [llength $list_node]
	return $list_node
}

#tao rbe2 cho cac node tim duoc trong khoang x-100 x+100 doi voi X la xog cua comp cho truoc
proc create_SPC_B09 {gotail_b09 id_b09} {
	puts "Run create_SPC_B09"
	puts "------------------"
	set comp_id [lindex $id_b09 0]
	set load_id [lindex $id_b09 1]
	set node_rigid []
	foreach ass $gotail_b09 {
		set x [lindex $ass 0]
		set listpid [lindex $ass 1]
		if {$listpid == ""} {
			break
		}
		eval *createmark nodes 1 "by comp id" $listpid
		set nodes_list [hm_getmark nodes 1]
		foreach node $nodes_list {
			set x_coord [hm_getvalue nodes id=$node dataname=x]
			set z_coord [hm_getvalue nodes id=$node dataname=z]
			if {$x_coord <= [expr $x + 200.5] && $z_coord <200 && $x_coord >= [expr $x  - 0.5]} {
				lappend node_rigid $node
			}
		}			
	}
	if {[llength $node_rigid] != 0} {
		set node_rigid [loc_node_1D $node_rigid]
		set load_id "12345678"
		*createmark loadcols 2 "by id only" $load_id
		set spc [hm_getmark loadcols 2]
		if {! [Null spc]} {
			set name_loadcols [hm_getvalue loadcols id=$load_id dataname=name]
			*currentcollector loadcols "$name_loadcols"
			*loadsize 1 100 0 1
			eval *createmark nodes 1 $node_rigid
			*loadcreateonentity_curve nodes 1 3 1 0 0 0 0 0 0 0 0 0 0 0
			*clearmark nodes 1
		} else {
			*createentity loadcols id=$load_id name = "SPC_B09_rigird" 
			*loadsize 1 100 0 1
			eval *createmark nodes 1 $node_rigid
			*loadcreateonentity_curve nodes 1 3 1 0 0 0 0 0 0 0 0 0 0 0
			*clearmark nodes 1
		}
		
		*clearmark loadcols 2
		*createmark loadcols 1 "by name only" "SPC_B09_rigird"
		set load_b09 [hm_getmark loadcols 1]
		if {! [Null load_b09]} {
			set b09 [lindex $id_b09 0]
			foreach id $b09 {
				*createmark loadcols 2 "by id only" $id
				set spc [hm_getmark loadcols 2]
				if {! [Null spc]} {
				*createmark loads 1 "by loadcols id" 12345678
				*copymark loads 1 $SPC_B09_rigird
				} else {
					*createentity loadcols id=$id name=$id
					*createmark loads 1 "by loadcols id" 12345678
					*copymark loads 1 $id
				}
			}
			*createmark loadcols 1 "SPC_B09_rigird"
			*deletemark loadcols 1
		}
	}		
}

#lam file tinh toan (.dat) cho DOU
proc dat_dou {assem} {
	puts "Run dat_dou"
	puts "------------------"
	variable gui; global glo ; global filemodel; global outputfolder; global supportfolder
	set support_folder $supportfolder
	set file_dat_input "$support_folder/dou.dat"
	set output_folder $outputfolder
	set model $filemodel
	set spli_model [split $model "/"]
	set l [llength $spli_model]
	set name_master [lindex $spli_model [expr $l - 1]]
	set name_tile [string map "0BI_Master.nas 0" $name_master]
	set link_master "$output_folder/00_Model"
	foreach ass $assem {
		set assy_name [lindex $ass 0]
		set bango [lindex $ass 1]
		set include ""
		if {$assy_name == "DOU" && $bango != ""} {
			set name [lindex $ass 2]
			set tanso [lindex $ass 11]
			set botls [lindex $ass 6]
			set beams [lindex $ass 7]
			set data_data [lindex $ass 10]
			set link_folder "$output_folder/$name"
			set files [glob -directory $link_folder -- *]
			foreach file $files {
				if {[string first ".hexa" $file] != -1 || [string first ".rbe3" $file] != -1 
					|| [string first ".set" $file] != -1 || [string first ".uset" $file] != -1
					|| [string first ".nas" $file] != -1} {
					set spli_file [split $file "/"]
					set len_file [llength $spli_file]
					set name_inclu [lindex $spli_file [expr $len_file - 1]]
					append include "INCLUDE '$name_inclu'"
					append include "\n"
				}
			}
			append include "ENDDATA"
			if {$data_data == "ã€‡"} { 
				set file_dat_input1 "$support_folder/DAT-DATA/$bango.dat"
				set dat_input "$file_dat_input1"
				set readfile [open $dat_input r]
				set lines [read $readfile]
				close $readfile
				set list_line [split $lines "\n"]
				set leng_all [llength $list_line]
				set title_incl [lsearch $list_line "INCLUDE*"]
				if {$title_incl != -1} {
					set list_line [lreplace $list_line $title_incl $leng_all]
					set lines [join $list_line "\n"]
				}
				append lines "\n"
				append lines $include
				set list_line [split $lines "\n"]
				set list_line [lremove -all $list_line [list {}]]
				set ouput_dat [string map "Master.nas $bango" $name_master]
				set new_file_dat "$output_folder/$name/$ouput_dat.dat"
				set writefile [open $new_file_dat w]
				puts $writefile $lines
				close $writefile			
			} 
			if {$data_data == ""} {
				set node_local [lindex $ass 8]
				set node_golbal [lindex $ass 9]
				set data_force []
				set dat_input "$file_dat_input"
				set readfile [open $dat_input r]
				set lines [read $readfile]
				close $readfile
				set list_line [split $lines "\n"]
				set title_check [lsearch $list_line "TITLE =*"]
				set title_line "TITLE = $name_tile"
				set list_line [lreplace $list_line $title_check $title_check $title_line]
				set subtitle_check [lsearch $list_line "SUBTITLE =*"]
				set subtitle_line "SUBTITLE = $name"
				set list_line [lreplace $list_line $subtitle_check $subtitle_check $subtitle_line]
				if {$tanso == 100} {
					set line_0 [lindex $list_line 0]
					set line_0 "$ $line_0"
					set list_line [lreplace $list_line 0 0 $line_0]
				}
				if {$tanso == 80} { #sua cai nay 16/10
					set line_0 [lindex $list_line 0]
					set line_0 "$ $line_0"
					set list_line [lreplace $list_line 0 0 $line_0]
					set sp_check [lsearch $list_line "$  SUPPORT"]
					set len_list [llength $list_line]
					if {$sp_check != -1} {
						set list_line [lreplace $list_line $sp_check $len_list]
						lappend list_line "$------1-------2-------3-------4-------5-------6-------7-------8-------9-------0"
					}
				}
				set tanso_check [lsearch $list_line "EIGRL*"]
				set line_tanso_check [lindex $list_line $tanso_check]
				
				set line_tanso [string map "tanso $tanso" $line_tanso_check]
				# set line_tanso "EIGRL   90                $tanso"
				set list_line [lreplace $list_line $tanso_check $tanso_check $line_tanso]
				set force_posion [expr $tanso_check + 2]
				set node 5001
				if {$botls != ""} {
					eval *createmark nodes 1 $botls
					set node_bolts [hm_getmark nodes 1]
					*clearmark nodes 1
					foreach node_botl $node_bolts {
						if {[file exists "$output_folder/plot/$node_botl\-BOTL-PLOT-FORCE.nas"]==1} {
							set botl_file "$output_folder/plot/$node_botl\-BOTL-PLOT-FORCE.nas"
							set readfile_botl [open $botl_file r]
							set lines_botl [read $readfile_botl]
							set node2 [expr $node +1]
							set node3 [expr $node +2]
							set lines_botl [string map "5001 $node" $lines_botl]
							set lines_botl [string map "5002 $node2" $lines_botl]
							set lines_botl [string map "5003 $node3" $lines_botl]
							append data_force $lines_botl
							set node [expr $node + 3]
							close $readfile_botl
							# lappend data_force "\n"
						}
					}
				}
				if {$beams != ""} {
					eval *createmark nodes 1 $beams
					set node_beams [hm_getmark nodes 1]
					*clearmark nodes 1
					foreach node_beam $node_beams {
						if {[file exists "$output_folder/plot/$node_beam\-BEAM-PLOT-FORCE.nas"]==1} {
							set beam_file "$output_folder/plot/$node_beam\-BEAM-PLOT-FORCE.nas"
							set readfile_beam [open $beam_file r]
							set lines_beam [read $readfile_beam]
							close $readfile_beam
							set node2 [expr $node +1]
							set node3 [expr $node +2]
							set lines_beam [string map "5001 $node" $lines_beam]
							set lines_beam [string map "5002 $node2" $lines_beam]
							set lines_beam [string map "5003 $node3" $lines_beam]
							append data_force $lines_beam
							set node [expr $node + 3]
							# lappend data_force "\n"
						}
					}
				}
				if {$node_local != ""} {
					eval *createmark nodes 1 $node_local
					set node_locals [hm_getmark nodes 1]
					*clearmark nodes 1
					foreach node_loc $node_locals {
						if {[file exists "$output_folder/plot/$node_loc\-NODE_local-PLOT-FORCE.nas"]==1} {
							set node_local_file "$output_folder/plot/$node_loc\-NODE_local-PLOT-FORCE.nas"
							set readfile_local [open $node_local_file r]
							set lines_local [read $readfile_local]
							set lines_local [string map "5001 $node" $lines_local]
							append data_force $lines_local
							set node [expr $node +1]
							close $readfile_local
							# lappend data_force "\n"
						}
					}
				}
				if {$node_golbal != ""} { 
					eval *createmark nodes 1 $node_golbal
					set node_golbals [hm_getmark nodes 1]
					*clearmark nodes 1
					foreach node_glo $node_golbals {
						if {[file exists "$output_folder/golbal/$node_glo\_local.dat"]==1} {
							set golbal_file "$output_folder/golbal/$node_glo\_local.dat"
							set readfile_golbal [open $golbal_file r]
							set lines_gol [read $readfile_golbal]
							set node2 [expr $node +1]
							set node3 [expr $node +2]
							set lines_gol [string map "5001 $node" $lines_gol]
							set lines_gol [string map "5002 $node2" $lines_gol]
							set lines_gol [string map "5003 $node3" $lines_gol]
							append data_force $lines_gol
							set node [expr $node + 3]
							close $readfile_golbal
							# lappend data_force "\n"
						}
					}
				}
				set a [string length $data_force]
				set data_force [string replace $data_force [expr $a-1] [expr $a -1] ""]
				set list_line [linsert $list_line $force_posion $data_force]
				# append lines "\n"
				lappend list_line $include
				set list_line [lremove -all $list_line [list {}]]
				set ouput_dat [string map "Master.nas $bango" $name_master]
				set new_file_dat "$output_folder/$name/$ouput_dat.dat"
				set writefile [open $new_file_dat w]
				puts $writefile [join $list_line "\n"]
				close $writefile
			}
		}
	}
}

#Dinh nghia luc cho tung node golbal
proc node_global_dat {node_globals} {
	puts "Run node_global_dat"
	puts "------------------"
	variable gui; global glo ; global filemodel; global outputfolder; global supportfolder
	set output_folder $outputfolder	
	file mkdir "$output_folder/golbal"
	foreach node_data $node_globals {
		set node_global [lindex $node_data 0]
		if {$node_global == ""} {
			break
		}
		set b [string length $node_global]
		set node_global [string replace $node_global [expr $b-2] [expr $b -1] ""]
		set line1 "$    NODE ID : $node_global"
		set node 5001
		set data_golbal ""
		append data_golbal $line1
		append data_golbal "\n"
		for {set i 1} {$i < [llength $node_data]} {incr i} {
			if {[lindex $node_data $i] != 0} {
				set line2 "LSEQ         999    $node   $node"
				set node [expr $node + 1]
				append data_golbal $line2
				append data_golbal "\n"
			}
		}
		set node 5001
		for {set i 1} {$i < [llength $node_data]} {incr i} {
			if {[lindex $node_data $i] != 0} {
				set force [lindex $node_data $i]
				if {[string length $node_global]==3} {
					set line2 "FORCE       $node     $node_global       $force"
					set node [expr $node + 1]
					append data_golbal $line2
					append data_golbal "\n"
				}
				if {[string length $node_global]==4} {
					set line2 "FORCE       $node    $node_global       $force"
					set node [expr $node + 1]
					append data_golbal $line2
					append data_golbal "\n"
				}
			}
		}
		set a [string length $data_golbal]
		set data_golbal [string replace $data_golbal [expr $a-1] [expr $a -1] ""]
		set new_file_dat "$output_folder/golbal/$node_global\_local.dat"
		set writefile [open $new_file_dat w]
		puts $writefile $data_golbal
		close $writefile
		# puts $data_golbal
	}
}

#run marcro VBA de tinh luc cho tung node local
proc run_VBA_node {assem} {
	puts "Run run_VBA_node"
	puts "------------------"
	variable gui; global glo ; global filemodel; global outputfolder; global supportfolder
	set support_folder $supportfolder
	set file_men "$support_folder/MENCHOKU-FORCE.xls"
	set output_folder $outputfolder
	set excel_file "$file_men"
	package require twapi
	set excel [::twapi::comobj Excel.Application]
	$excel DisplayAlerts [expr 0]
	set workbooks [$excel Workbooks]
	$workbooks Open "$excel_file"
	set workbook [$workbooks Item 1]
	set sheets [$workbook Sheets]
	set sheet [$sheets Item 1]
	set cells [$sheet Cells]
	foreach ass $assem {
		set assy_name [lindex $ass 0]
		set node_local [lindex $ass 8]
		set dat_data [lindex $ass 10]
		if {$assy_name == "DOU" && $node_local != "" && $dat_data != "ã€‡"} {
			set bango [lindex $ass 1]
			set name [lindex $ass 2]
			if {$bango == ""} {
				break
			}
			eval *createmark nodes 1 $node_local
			set node_locals [hm_getmark nodes 1]
			foreach node $node_locals {
				if {[file exists "$output_folder/plot/$node\-NODE_local-PLOT.nas"]==1
					&& [file exists "$output_folder/plot/$node\-NODE_local-PLOT-FORCE.nas"]==0} {
					$cells Item 1 M "$output_folder/plot/$node\-NODE_local-PLOT.nas" 
					$cells Item 10 K "$node"
					$excel Run active_menchoku
					$excel Run TCL_readfile
					$excel Run tinh
					$excel Run Paste
					$excel Run xuatfilenas
					$excel Run clear
				}
			}
		}
	}
	
	$excel Quit
	$cells -destroy
	$sheet -destroy
	$sheets -destroy
	$workbook -destroy
	$workbooks -destroy
	$excel -destroy
	unset excel
}

#run macro VBA de tinh luc cua tung botl
proc run_VBA_botl {list_truc_botl} {
	puts "Run run_VBA_botl"
	puts "------------------"
	variable gui; global glo ; global filemodel; global outputfolder; global supportfolder
	set support_folder $supportfolder
	set file_force "$support_folder/TSUKURU-FORCE.xls"
	set output_folder $outputfolder
	set excel_file "$file_force"
	package require twapi
	set excel [::twapi::comobj Excel.Application]
	$excel DisplayAlerts [expr 0]
	set workbooks [$excel Workbooks]
	$workbooks Open "$excel_file"
	set workbook [$workbooks Item 1]
	set sheets [$workbook Sheets]
	set sheet [$sheets Item 1]
	set cells [$sheet Cells]
	foreach list_botl $list_truc_botl {
		set bango [lindex $list_botl 0]
		set name [lindex $list_botl 1]
		set len_a [llength $list_botl]
		for {set i 2} {$i < [expr $len_a]} {incr i} {
			set x [lindex $list_botl $i]
			set node [lindex $x 0]
			set truc [lindex $x 1]
			if {[file exists "$output_folder/plot/$node\-BOTL-PLOT.nas"]==1
			&& [file exists "$output_folder/plot/$node\-BOTL-PLOT-FORCE.nas"]==0 } {
				$cells Item 1 C "$output_folder/plot/$node\-BOTL-PLOT.nas"
				$cells Item 10 K "$node"
				$cells Item 10 L "$truc"
				$excel Run active_boruto
				$excel Run TCL_readfile
				$excel Run xapxep
				$excel Run Tinhtoan
				$excel Run Paste
				$excel Run xuatfilenas
				$excel Run clear
			}
		}
	}
	$excel Quit
	$cells -destroy
	$sheet -destroy
	$sheets -destroy
	$workbook -destroy
	$workbooks -destroy
	$excel -destroy
	unset excel
}

#tim truc cua tung botl
proc truc_botl {assem} {
	puts "Run truc_botl"
	puts "------------------"
	set truc_botl []
	foreach ass $assem {
		set assy_name [lindex $ass 0]
		set botls [lindex $ass 6]
		set dat_data [lindex $ass 10]
		if {$assy_name == "DOU" && $botls != "" && $dat_data != "ã€‡"} {
			set bango [lindex $ass 1]
			set name [lindex $ass 2]
			if {$bango == ""} {
				break
			}
			eval *createmark nodes 1 $botls
			set node_bolts [hm_getmark nodes 1]
			*clearmark nodes 1
			set list_bango_node []
			lappend list_bango_node $bango
			lappend list_bango_node $name
			foreach node_botl $node_bolts {
				set list_node_truc []
				*createmark nodes 1 "by comps name" "$node_botl\-BOTL-PLOT"
				set node_truc [hm_getmark nodes 1]
				set node1 [lindex $node_truc 1]
				if {$node1 == $node_botl} {
					set node1 [lindex $node_truc 3]
				}
				set node2 [lindex $node_truc 2]
				if {$node2 == $node_botl} {
					set node2 [lindex $node_truc 3]
				}			
				set a1 [hm_getvalue node id=$node1 dataname=x]
				set b1 [hm_getvalue node id=$node1 dataname=y]
				set c1 [hm_getvalue node id=$node1 dataname=z]
				
				set a3 [hm_getvalue node id=$node2 dataname=x]
				set b3 [hm_getvalue node id=$node2 dataname=y]
				set c3 [hm_getvalue node id=$node2 dataname=z]
				## sua lai phuong phap xac dinh truc 24022024
				
				set a2 [hm_getvalue node id=$node_botl dataname=x]
				set b2 [hm_getvalue node id=$node_botl dataname=y]
				set c2 [hm_getvalue node id=$node_botl dataname=z]
				
				set AB [list [expr {$a2 - $a1}] [expr {$b2 - $b1}] [expr {$c2 - $c1}]]
				set AC [list [expr {$a3 - $a1}] [expr {$b3 - $b1}] [expr {$c3 - $c1}]]
				set dx [expr {[lindex $AB 1] * [lindex $AC 2] - [lindex $AB 2] * [lindex $AC 1]}]
				set dy [expr {[lindex $AB 2] * [lindex $AC 0] - [lindex $AB 0] * [lindex $AC 2]}]
				set dz [expr {[lindex $AB 0] * [lindex $AC 1] - [lindex $AB 1] * [lindex $AC 0]}]
				*createmark nodes 1 $node_botl
				*duplicatemark nodes 1 28
				*createvector 1 $dx  $dy $dz
				*translatemark nodes 1 1 10
				set node_new [hm_latestentityid nodes]
				
				set x1 [hm_getvalue node id=$node_new dataname=x]
				set y1 [hm_getvalue node id=$node_new dataname=y]
				set z1 [hm_getvalue node id=$node_new dataname=z]			
				
				*createnode $x1 $y1 $c2 0 0 0
				set node_z [hm_latestentityid nodes]
				*createnode $x1 $b2 $z1 0 0 0
				set node_y [hm_latestentityid nodes]
				*createnode $a2 $y1 $z1 0 0 0
				set node_x [hm_latestentityid nodes]
				set angel_x [hm_getangle nodes $node_new $node_botl $node_x]
				set angel_y [hm_getangle nodes $node_new $node_botl $node_y]
				set angel_z [hm_getangle nodes $node_new $node_botl $node_z]
				set min_c [expr max($angel_x,$angel_y,$angel_z)]		
				# puts "$node_botl $a1 $a2 $a3"
				# puts "$node_botl $b1 $b2 $b3"
				# puts "$node_botl $c1 $c2 $c3"
				if {abs($a1 - $a2) < 0.3 && abs($a1 - $a3) < 0.3} {
					set truc 1
				} elseif {abs($b1 - $b2) < 0.3 && abs($b1 - $b3) < 0.3} {
					set truc 2
				} elseif {abs($c1 - $c2) < 0.3 && abs($c1 - $c3) < 0.3} {
					set truc 3
				} else {
					if {$min_c == $angel_x} {
						set truc 1
					}
					if {$min_c == $angel_y} {
						set truc 2
					}
					if {$min_c == $angel_z} {
						set truc 3
					}
				}
				lappend list_node_truc $node_botl
				lappend list_node_truc $truc
				lappend list_bango_node $list_node_truc
			}
			lappend truc_botl $list_bango_node
		}
	}
	*createmark nodes 1 "all"
	*nodemarkaddtempmark 1
	*nodecleartempmark 
	puts $truc_botl
	return $truc_botl
}

#Run marcro VBA de tinh luc dat vao tung BEAM
proc run_VBA_beam {list_truc_beam} {
	puts "Run run_VBA_beam"
	puts "------------------"
	variable gui; global glo ; global filemodel; global outputfolder; global supportfolder
	set support_folder $supportfolder
	set file_force "$support_folder/TSUKURU-FORCE.xls"
	set output_folder $outputfolder
	set excel_file "$file_force"
	package require twapi
	set excel [::twapi::comobj Excel.Application]
	$excel DisplayAlerts [expr 0]
	set workbooks [$excel Workbooks]
	$workbooks Open "$excel_file"
	set workbook [$workbooks Item 1]
	set sheets [$workbook Sheets]
	set sheet [$sheets Item 2]
	set cells [$sheet Cells]
	foreach list_beam $list_truc_beam {
		set bango [lindex $list_beam 0]
		set name [lindex $list_beam 1]
		set len_a [llength $list_beam]
		for {set i 2} {$i < [expr $len_a]} {incr i} {
			set x [lindex $list_beam $i]
			set node [lindex $x 0]
			set truc [lindex $x 1]
			if {[file exists "$output_folder/plot/$node\-BEAM-PLOT.nas"]==1} {
				$cells Item 1 C "$output_folder/plot/$node\-BEAM-PLOT.nas"
				$cells Item 10 K "$node"
				$cells Item 10 L "$truc"
				$excel Run active_beam
				$excel Run TCL_readfile
				$excel Run xapxep
				$excel Run TinhtoanBeam
				$excel Run Paste
				$excel Run xuatfilenas
				$excel Run clear
			}
		}
	}
	
		
	$excel Quit
	$cells -destroy
	$sheet -destroy
	$sheets -destroy
	$workbook -destroy
	$workbooks -destroy
	$excel -destroy
	unset excel
}

#tim truc cua tung Beam
proc truc_beam {assem} {
	puts "Run truc_beam"
	puts "------------------"
	set truc_beam []
	foreach ass $assem {
		set assy_name [lindex $ass 0]
		set beams [lindex $ass 7]
		set dat_data [lindex $ass 10]
		if {$assy_name == "DOU" && $beams != "" && $dat_data != "ã€‡"} {
			set bango [lindex $ass 1]
			set name [lindex $ass 2]
			if {$bango == ""} {
				break
			}
			eval *createmark nodes 1 $beams
			set node_beams [hm_getmark nodes 1]
			*clearmark nodes 1
			set list_bango_node []
			lappend list_bango_node $bango
			lappend list_bango_node $name
			foreach node_beam $node_beams {
				set list_node_truc []
				*createmark nodes 1 "by comps name" "$node_beam\-BEAM-PLOT"
				set node_truc [hm_getmark nodes 1]
				*clearmark nodes 1
				set node1 [lindex $node_truc 0]
				set node2 [lindex $node_truc 1]
				set x1 [hm_getvalue node id=$node1 dataname=x]
				set y1 [hm_getvalue node id=$node1 dataname=y]
				set z1 [hm_getvalue node id=$node1 dataname=z]
				
				set x2 [hm_getvalue node id=$node2 dataname=x]
				set y2 [hm_getvalue node id=$node2 dataname=y]
				set z2 [hm_getvalue node id=$node2 dataname=z]
				*createnode $x1 $y1 $z2 0 0 0
				set node_z [hm_latestentityid nodes]
				*createnode $x1 $y2 $z1 0 0 0
				set node_y [hm_latestentityid nodes]
				*createnode $x2 $y1 $z1 0 0 0
				set node_x [hm_latestentityid nodes]
				set angel_x [hm_getangle nodes $node1 $node2 $node_x]
				set angel_y [hm_getangle nodes $node1 $node2 $node_y]
				set angel_z [hm_getangle nodes $node1 $node2 $node_z]
				if {$angel_x == 45 } {
					set truc 1
				} elseif {$angel_y == 45 } {
					set truc 2
				} elseif {$angel_z == 45 } {
					set truc 3
				} else {
					set max [expr max($angel_x,$angel_y,$angel_z)]
					if {$max == $angel_x} {
						set truc 1
					}
					if {$max == $angel_y} {
						set truc 2
					}
					if {$max == $angel_z} {
						set truc 3
					}
				}
				lappend list_node_truc $node_beam
				lappend list_node_truc $truc
				lappend list_bango_node $list_node_truc
			}
			lappend truc_beam $list_bango_node
		}
	}
	*createmark nodes 1 "all"
	*nodemarkaddtempmark 1
	*nodecleartempmark 
	return $truc_beam
}

#xuat file tinh toan cua DOU
proc export_data_dou {assem mats} {
	puts "Run export_data_dou"
	puts "------------------"
	variable gui; global glo ; global filemodel; global outputfolder; global supportfolder
	set output_folder $outputfolder
	set model $filemodel
	set spli_model [split $model "/"]
	set l [llength $spli_model]
	set name_master [lindex $spli_model [expr $l - 1]]
	set mat1 [lindex $mats 0]
	set mat2 [lindex $mats 1]
	set mat3 [lindex $mats 2]
	
	foreach ass $assem {
		set assy_name [lindex $ass 0]
		if {$assy_name == "DOU"} {
			set bango [lindex $ass 1]
			if {$bango == ""} {
				break
			}
			set master_check "Master"
			set name_output [string map "$master_check $bango" $name_master]
			set name [lindex $ass 2]
			set mat10 [lindex $ass 3]
			set mat11 [lindex $ass 4]
			set mat12 [lindex $ass 5]
			set botl [lindex $ass 6]
			set beam [lindex $ass 7]
			set node_exp [lindex $ass 8]
			set assy_maru [lindex $ass 12]
			set assy_batu [lindex $ass 13]
			set comps [lindex $ass 14]
			set plot [lindex $ass 15]
			
			if {$mat10 != ""} {
				*createmark mats 1 $mat1
				set mats10 [hm_getmark mats 1]
				if {! [Null mats10]} {
					*setvalue mats id=$mat1 STATUS=1 1=$mat10
				}
			}
			if {$mat11 != ""} {
				*createmark mats 1 $mat2
				set mats11 [hm_getmark mats 1]
				if {! [Null mats11]} {
					*setvalue mats id=$mat2 STATUS=1 1=$mat11
				}	
			}
			if {$mat12 != ""} {
				*createmark mats 1 $mat3
				set mats12 [hm_getmark mats 1]
				if {! [Null mats12]} {
					*setvalue mats id=$mat3 STATUS=1 1=$mat12
				}
			}
			
			eval *createmark assemblies 2 $assy_maru
			*createstringarray 2 "elements_on" "geometry_on"
			*isolateonlyentitybymark 2 1 2
			*clearmark assemblies 2

			eval *createmark components 2 $comps
			*createstringarray 2 "elements_on" "geometry_on"
			*showentitybymark 2 1 2
			*clearmark components 2

			eval *createmark assemblies 2 $assy_batu
			*createstringarray 2 "elements_on" "geometry_on"
			*hideentitybymark 2 1 2
			*clearmark assemblies 2
			
			file mkdir "$output_folder/$name"
			file mkdir "$output_folder/plot"
			*retainmarkselections 0
			*createstringarray 4 "HM_REAL_VALUES_E_OPTION " "HM_NODEELEMS_SET_COMPRESS_SKIP " "EXPORT_SYSTEM_LONGFORMAT " \
				  "HMBOMCOMMENTS_XML"
			set template [hm_info -appinfo SPECIFIEDPATH TEMPLATES_DIR]
			*feoutputwithdata "$template/feoutput/nastran/general" "$output_folder/$name/$name_output" 0 0 0 1 4
			
			set nas_file "$output_folder/$name/$name_output"
			set readfile [open $nas_file r]
			set lines [read $readfile]
			set list_line [split $lines "\n"]
			close $readfile
			set cord2r [lsearch $list_line "CORD2R*"]
			if {$cord2r != -1 } {
				set i $cord2r
			} else {
				set i [lsearch $list_line "$$  GRID Data"]
			}
			if {$i != -1} {
				set newline1 [lreplace $list_line 0 [expr $i-1]]
			} else {
				set newline1 $list_line
			}
			set j [lsearch $newline1 "ENDDATA*"]
			if {$j != -1} {
				set newline [lreplace $newline1 $j end]
			} else {
				set newline $newline1
			}
			set newline [lremove -all $newline [list {}]]
			set writefile [open $nas_file w]
			puts $writefile [join $newline "\n"]
			close $writefile	
		}
	}
} 

#tao comp luu tru cac node local rooi xuat file tuong ung
proc add_node_local {assem} {
	puts "Run add_node_local"
	puts "------------------"
	variable gui; global glo ; global filemodel; global outputfolder; global supportfolder
	set output_folder $outputfolder
	set loadcols_all [hm_entitylist loadcols id]
	eval *createmark loadcols 2 $loadcols_all
	*createstringarray 2 "elements_on" "geometry_on"
	*hideentitybymark 2 1 2
	*clearmark loadcols 2
	foreach data $assem {
		set assy_name [lindex $data 0]
		set node_plot [lindex $data 8]
		set dat_data [lindex $data 8]
		if {$assy_name == "DOU" && $node_plot != "" && $dat_data != "ã€‡"} {
			set bango [lindex $data 1]
			set name [lindex $data 2]
			set name_node_local [lindex $data 2]
			eval *createmark nodes 1 $node_plot
			set node_locals [hm_getmark nodes 1]
			foreach node_local $node_locals {
				*createmark comps 2 "by name only" "$node_local\-NODE_local-PLOT"
				set comp_name_check [hm_getmark comps 2]
				if {! [Null comp_name_check]} {
					continue
				} else {
					*createentity comps name= $node_local\-NODE_local-PLOT
					set comps_all [hm_entitylist comps id]
					eval *createmark components 2 $comps_all
					*createstringarray 2 "elements_on" "geometry_on"
					*hideentitybymark 2 1 2
					*createmark nodes 1 $node_local
					*findmark nodes 1 257 1 elements 0 2
					*createmark elements 1 "displayed"
					set ele_dis [hm_getmark elements 1]
					set list_ele_ofset []
					foreach ele $ele_dis {
						*clearmark nodes 1
						*clearmark elements 1
						*createmark nodes 1 "by element id" $ele
						set sum_node_check [hm_getmark nodes 1]
						*clearmark nodes 1
						if {[llength $sum_node_check] == 4} {
							lappend list_ele_ofset $ele
						}
					}
					eval *createmark elements 1 $list_ele_ofset
					*copymark elements 1 "$node_local\-NODE_local-PLOT"
					*createmark elem 1 "by comps name" "$node_local\-NODE_local-PLOT"
					set elem_delete [hm_getmark elem 1]
					*clearmark elem 1
					eval *createmark elements 1 $elem_delete
					*shelloffset 1 0 0 0.5 0
					*createmark nodes 1 "all"
					*nodemarkaddtempmark 1
					*nodecleartempmark
					set comp_keep [hm_getvalue elems user_ids=[lindex $list_ele_ofset 0] dataname=component.id]
					*createmark comps 1 "displayed" 
					set comps_display [hm_getmark comps 1]
					*clearmark comps 1
					foreach comp $comps_display {
						if {$comp != $comp_keep} {
							*createmark components 2 $comp
							*createstringarray 2 "elements_on" "geometry_on"
							*hideentitybymark 2 1 2
							*clearmark components 2
						}
					}
					if {[file exists "$output_folder/plot/$node_local\-NODE_local-PLOT.nas"] == 1} {
						continue
					} else {
						*createmark components 2 "$node_local\-NODE_local-PLOT"
						*createstringarray 2 "elements_on" "geometry_on"
						*showentitybymark 2 1 2
						*clearmark components 2
						*retainmarkselections 0
						file mkdir "$output_folder/plot"
						*createstringarray 4 "HM_REAL_VALUES_E_OPTION " "HM_NODEELEMS_SET_COMPRESS_SKIP " "EXPORT_SYSTEM_LONGFORMAT " \
							  "HMBOMCOMMENTS_XML"
						set template [hm_info -appinfo SPECIFIEDPATH TEMPLATES_DIR]
						*feoutputwithdata "$template/feoutput/nastran/general" "$output_folder/plot/$node_local\-NODE_local-PLOT.nas" 0 0 0 1 4
					}
				}
			}
		}
	}
}

#xuat thong tin plot cua beam va botl lam phia duoi
proc exprot_plot {assem} {
	puts "Run exprot_plot"
	puts "------------------"
	variable gui; global glo ; global filemodel; global outputfolder; global supportfolder
	set output_folder $outputfolder
	file mkdir "$output_folder/plot"
	foreach ass $assem {
		set assy_name [lindex $ass 0]
		set bango [lindex $ass 1]
		set dat_data [lindex $ass 10]
		if {$assy_name == "DOU" && $bango != "" && $dat_data != "ã€‡"} {
			set botl [lindex $ass 6]
			set beam [lindex $ass 7]
			if {$botl != ""} {
				eval *createmark nodes 1 $botl
				set node_botls [hm_getmark nodes 1]
				*clearmark nodes 1
				foreach node_botl $node_botls {
					set botl_name "$node_botl\-BOTL-PLOT.nas"
					if {[file exists "$output_folder/plot/$botl_name"] == 1} {
						continue
					} else {
						*createmark components 2 "$node_botl\-BOTL-PLOT"
						*createstringarray 2 "elements_on" "geometry_on"
						*isolateonlyentitybymark 2 1 2
						*retainmarkselections 0
						*createstringarray 4 "HM_REAL_VALUES_E_OPTION " "HM_NODEELEMS_SET_COMPRESS_SKIP " "EXPORT_SYSTEM_LONGFORMAT " \
								"HMBOMCOMMENTS_XML"
						set template [hm_info -appinfo SPECIFIEDPATH TEMPLATES_DIR]
						*feoutputwithdata "$template/feoutput/nastran/general" "$output_folder/plot/$botl_name" 0 0 0 1 4
						}
					}
				}
			if {$beam != ""} { 
				eval *createmark nodes 1 $beam
				set node_beams [hm_getmark nodes 1]
				*clearmark nodes 1
				foreach node_beam $node_beams {
					set beam_name "$node_beam\-BEAM-PLOT.nas"
					if {[file exists "$output_folder/plot/$beam_name"] == 1} {
						continue
					} else {
						*createmark components 2 "$node_beam\-BEAM-PLOT"
						*createstringarray 2 "elements_on" "geometry_on"
						*isolateonlyentitybymark 2 1 2
						*retainmarkselections 0
						*createstringarray 4 "HM_REAL_VALUES_E_OPTION " "HM_NODEELEMS_SET_COMPRESS_SKIP " "EXPORT_SYSTEM_LONGFORMAT " \
							  "HMBOMCOMMENTS_XML"
						set template [hm_info -appinfo SPECIFIEDPATH TEMPLATES_DIR]
						*feoutputwithdata "$template/feoutput/nastran/general" "$output_folder/plot/$beam_name" 0 0 0 1 4
					}
				}
			}
		}
	}
}

#tao plot cho cac node lam beam
proc beam_add {assem} {
	puts "Run beam_add"
	puts "------------------"
	set loadcols_all [hm_entitylist loadcols id]
	eval *createmark loadcols 2 $loadcols_all
	*createstringarray 2 "elements_on" "geometry_on"
	*hideentitybymark 2 1 2
	*clearmark loadcols 2
	foreach data $assem {
		set assy_name [lindex $data 0]
		set beam [lindex $data 7]
		set dat_data [lindex $data 10]
		if {$assy_name == "DOU" && $beam != "" && $dat_data != "ã€‡"} {
			set bango [lindex $data 1]
			set name [lindex $data 2]
			# set beam [lindex $data 7]
			eval *createmark nodes 1 $beam
			set node_beams [hm_getmark nodes 1]
			*clearmark nodes 1
			foreach node_beam $node_beams {
				*createmark comps 2 "by name only" "$node_beam\-BEAM-PLOT"
				set comp_name_check [hm_getmark comps 2]
				if {! [Null comp_name_check]} {
					continue
				} else {
					*createentity comps name= $node_beam\-BEAM-PLOT
					set comps_all [hm_entitylist comps id]
					eval *createmark components 2 $comps_all
					*clearmark components 1
					*createstringarray 2 "elements_on" "geometry_on"
					*hideentitybymark 2 1 2
					*createmark nodes 1 $node_beam
					*findmark nodes 1 257 1 elements 0 2
					*createmark elements 1 "displayed"
					set elems [hm_getmark elements 1]
					foreach elem $elems {
						*clearmark nodes 1
						*createmark nodes 1 "by elem id" $elem
						set sum_node [hm_getmark nodes 1]
						if {[llength $sum_node] == 2} {
							set node2 [hm_getvalue elem id=$elem dataname=node2]
							if {$node2 == $node_beam} {
								set node2 [hm_getvalue elem id=$elem dataname=node1]
							}
							*createlist nodes 1 $node_beam $node2
							*createelement 2 1 1 1
							*createmark nodes 1 "all"
							*nodemarkaddtempmark 1
							*nodecleartempmark 
						}
					}
				}
			}
		}
	}
}

#tao plot cho cac node botl
proc boruto_add {assem} {
	puts "Run boruto_add"
	puts "------------------"
	set loadcols_all [hm_entitylist loadcols id]
	eval *createmark loadcols 2 $loadcols_all
	*createstringarray 2 "elements_on" "geometry_on"
	*hideentitybymark 2 1 2
	*clearmark loadcols 2
	foreach data $assem {
		set assy_name [lindex $data 0]
		set botls [lindex $data 6]
		set bango [lindex $data 1]
		set dat_data [lindex $data 10]
		if {$bango == "F01-CTR" && $dat_data != "ã€‡" } {
			eval *createmark nodes 1 $botls
			set node_botls [hm_getmark nodes 1]
			*clearmark nodes 1
			foreach node_botl $node_botls {
				*createmark comps 2 "by name only" "$node_botl\-BOTL-PLOT"
				set comp_name_check [hm_getmark comps 2]
				if {! [Null comp_name_check]} {
					continue
				} else {
					*createentity comps name= $node_botl\-BOTL-PLOT
					set comps_all [hm_entitylist comps id]
					eval *createmark components 2 $comps_all
					*createstringarray 2 "elements_on" "geometry_on"
					*hideentitybymark 2 1 2
					*createmark nodes 1 $node_botl
					*findmark nodes 1 257 1 elements 0 2
					*createmark elements 1 "displayed"
					set ele_dis [hm_getmark elements 1]
					foreach ele $ele_dis {
						*clearmark nodes 1
						*clearmark elements 1
						*createmark nodes 1 "by element id" $ele
						set sum_node_check [hm_getmark nodes 1]
						set node1_check [hm_getvalue elem id=$ele dataname=node1]
						if {[llength $sum_node_check] == 4} {
							set node2_check [hm_getvalue elem id=$ele dataname=node2]
							set node3_check [hm_getvalue elem id=$ele dataname=node3]
							set node4_check [hm_getvalue elem id=$ele dataname=node4]
							*createlist nodes 1 $node1_check $node2_check
							*createelement 2 1 1 1
							*clearmark nodes 1
							*createlist nodes 1 $node1_check $node3_check
							*createelement 2 1 1 1
							*clearmark nodes 1
							*createlist nodes 1 $node1_check $node4_check
							*createelement 2 1 1 1
							*clearmark nodes 1
							
							*createmark nodes 1 "all"
							*nodemarkaddtempmark 1
							*nodecleartempmark 
						}
					}
				}
			}
		}
		
		if {$assy_name == "DOU" && $botls != "" && $bango != "F01-CTR" && $dat_data != "ã€‡" } {
			set name [lindex $data 2]
			eval *createmark nodes 1 $botls
			set node_botls [hm_getmark nodes 1]
			foreach node_botl $node_botls {
				*createmark comps 2 "by name only" "$node_botl\-BOTL-PLOT"
				set comp_name_check [hm_getmark comps 2]
				if {! [Null comp_name_check]} {
					continue
				} else {
					*createentity comps name= $node_botl\-BOTL-PLOT
					set comps_all [hm_entitylist comps id]
					eval *createmark components 2 $comps_all
					*createstringarray 2 "elements_on" "geometry_on"
					*hideentitybymark 2 1 2
					*createmark nodes 1 $node_botl
					*findmark nodes 1 257 1 elements 0 2
					*createmark elements 1 "displayed"
					set ele_dis [hm_getmark elements 1]
					foreach ele $ele_dis {
						*clearmark nodes 1
						*clearmark elements 1
						*createmark nodes 1 "by element id" $ele
						set sum_node_check [hm_getmark nodes 1]
						set node1_check [hm_getvalue elem id=$ele dataname=node1]
						if {[llength $sum_node_check] > 4 && $node1_check == $node_botl} {
							set node_2 ""
							set node_3 ""
							set node_4 ""
							set node_1 [hm_getvalue elem id=$ele dataname=node1]
							set r 100000
							foreach node_dis $sum_node_check {
								set dis_min [hm_getdistance nodes $node_1 $node_dis 0]
								if {$r > [lindex $dis_min 0] && $node_dis != $node_1} {
									set r [lindex $dis_min 0]
									set node_2 $node_dis
								}
							}
							foreach node_3f $sum_node_check {
								set dis_check [hm_getdistance nodes $node_1 $node_3f 0]
								set r_check [lindex $dis_check 0]
								set angel_32 [hm_getangle nodes $node_2 $node_1 $node_3f]
								if {$r_check < [expr $r + 4.5] && $angel_32 > 110 && $angel_32 < 140} {
									set node_3 $node_3f
								}
							}
							foreach node_4f $sum_node_check {
								set dis_check4 [hm_getdistance nodes $node_1 $node_4f 0]
								set r_check4 [lindex $dis_check4 0]
								set angel_24 [hm_getangle nodes $node_2 $node_1 $node_4f]
								set angel_34 [hm_getangle nodes $node_3 $node_1 $node_4f]
								if {$r_check4 < [expr $r + 4.5] && $angel_24 > 80 && $angel_34 > 80} {
									set node_4 $node_4f
								}
							}
							*createlist nodes 1 $node_1 $node_2
							*createelement 2 1 1 1
							*clearmark nodes 1
							*createlist nodes 1 $node_1 $node_3
							*createelement 2 1 1 1
							*clearmark nodes 1
							*createlist nodes 1 $node_1 $node_4
							*createelement 2 1 1 1
							*clearmark nodes 1
							
							*createmark nodes 1 "all"
							*nodemarkaddtempmark 1
							*nodecleartempmark 
						}
					}
				}
			}
		}
	}
}

#xuat thong tin tinh toan cua phan SEI
proc export_data_sei {assem mats} {
	puts "Run export_data_sei"
	puts "------------------"
	# foreach forc $force {
		# if {[lindex $forc 0]== 510 && [lindex $forc 5] < 0} {
			# set mag [lindex $forc 5]
			# *createmark loadcols 1 [lindex $forc 0]
			# set load_am [hm_getmark loadcols 1]
			
			# *createmark nodes 1 [lindex $forc 1]
			# set node_am [hm_getmark nodes 1]
		# }
	# }
	variable gui; global glo ; global filemodel; global outputfolder; global supportfolder
	set output_folder $outputfolder
	set model $filemodel
	set spli_model [split $model "/"]
	set l [llength $spli_model]
	set name_master [lindex $spli_model [expr $l - 1]]
	set mat1 [lindex $mats 0]
	set mat2 [lindex $mats 1]
	set mat3 [lindex $mats 2]
	foreach ass $assem {
		set assy_name [lindex $ass 0]
		if {$assy_name == "SEI" || $assy_name == "TA"} {
			set bango [lindex $ass 1]
			if {$bango == ""} {
				continue
			}
			set master_check "Master"
			set name_output [string map "$master_check $bango" $name_master]
			set name [lindex $ass 2]
			set mat10 [lindex $ass 3]
			set mat11 [lindex $ass 4]
			set mat12 [lindex $ass 5]
			set spcs [lindex $ass 6]
			set forcs [lindex $ass 7]
			set assy_maru [lindex $ass 12]
			set assy_batu [lindex $ass 13]
			set comps [lindex $ass 14]
			set plot [lindex $ass 15]
			

			if {$mat10 != ""} {
				*createmark mats 1 $mat1
				set mats10 [hm_getmark mats 1]
				if {! [Null mats10]} {
					*setvalue mats id=$mat1 STATUS=1 1=$mat10
				}
			}
			if {$mat11 != ""} {
				*createmark mats 1 $mat2
				set mats11 [hm_getmark mats 1]
				if {! [Null mats11]} {
					*setvalue mats id=$mat2 STATUS=1 1=$mat11
				}	
			}
			if {$mat12 != ""} {
				*createmark mats 1 $mat3
				set mats12 [hm_getmark mats 1]
				if {! [Null mats12]} {
					*setvalue mats id=$mat3 STATUS=1 1=$mat12
				}
			}
			
			eval *createmark assemblies 2 $assy_maru
			*createstringarray 2 "elements_on" "geometry_on"
			*isolateonlyentitybymark 2 1 2
			*clearmark assemblies 2

			eval *createmark components 2 $comps
			*createstringarray 2 "elements_on" "geometry_on"
			*showentitybymark 2 1 2
			*clearmark components 2

			eval *createmark loadcols 2 $forcs $spcs
			*createstringarray 2 "elements_on" "geometry_on"
			*showentitybymark 2 1 2
			*clearmark loadcols 2

			eval *createmark assemblies 2 $assy_batu
			*createstringarray 2 "elements_on" "geometry_on"
			*hideentitybymark 2 1 2
			*clearmark assemblies 2
			
			file mkdir "$output_folder/$name"
			*retainmarkselections 0
			*createstringarray 4 "HM_REAL_VALUES_E_OPTION " "HM_NODEELEMS_SET_COMPRESS_SKIP " "EXPORT_SYSTEM_LONGFORMAT " \
				  "HMBOMCOMMENTS_XML"
			set template [hm_info -appinfo SPECIFIEDPATH TEMPLATES_DIR]
			*feoutputwithdata "$template/feoutput/nastran/general" "$output_folder/$name/$name_output" 0 0 0 1 4
			# clear file output
				set nas_file "$output_folder/$name/$name_output"
				set readfile [open $nas_file r]
				set lines [read $readfile]
				close $readfile
				set list_line [split $lines "\n"]

				#tuong lai nen update de thay ro rang 1001 va 1002 check lai t2
				set line_pos [lsearch -all $list_line "FORCE        *"] 
				if {[llength $line_pos] >= 2} {
					foreach posi $line_pos {
						set line_check [lindex $list_line $posi]
						if {[string range $line_check 61 62] == "E+"} {
							# set line_duong $line_check
							set idx [lsearch $line_pos $posi]
							set data_duong [string range $line_check 0 15]
							set dat_keep [string range $line_check 16 23]
							set line_pos [lreplace $line_pos $idx $idx]
							foreach posi1 $line_pos {
								set line_check1 [lindex $list_line $posi1]
								if {[string range $line_check1 0 15] == $data_duong} {
									set mag [string range $line_check1 56 end]
									set idx1 [lsearch $line_pos $posi1]
									set new_line "$data_duong$dat_keep       0    -1.0     0.0     0.0$mag"
									set list_line [lreplace $list_line $posi $posi $new_line]
								}
							}
						}
					}
				}
					
				set cord2r [lsearch $list_line "CORD2R*"]
				if {$cord2r != -1 } {
					set i $cord2r
				} else {
					set i [lsearch $list_line "$$  GRID Data"]
				}
				if {$i != -1} {
					set newline1 [lreplace $list_line 0 [expr $i-1]]
				} else {
					set newline1 $list_line
				}
				set j [lsearch $newline1 "ENDDATA*"]
				if {$j != -1} {
					set newline [lreplace $newline1 $j end]
				} else {
					set newline $newline1
				}
				
				set newline [lremove -all $newline [list {}]]
				set writefile [open $nas_file w]
				puts $writefile [join $newline "\n"]
				close $writefile
		#export plot 
			if {[llength $plot] != 0} {
				set loadcols_all [hm_entitylist loadcols id]
				set comps_all [hm_entitylist comps id]
				eval *createmark components 2 $comps_all
				*createstringarray 2 "elements_on" "geometry_on"
				*hideentitybymark 2 1 2
				*clearmark components 2
				eval *createmark loadcols 2 $loadcols_all
				*createstringarray 2 "elements_on" "geometry_on"
				*hideentitybymark 2 1 2
				*clearmark loadcols 2
				
				set name_plot "$bango\-plot.nas"
				eval *createmark components 2 $plot
				*createstringarray 2 "elements_on" "geometry_on"
				*isolateonlyentitybymark 2 1 2
				*clearmark components 2
				
				*retainmarkselections 0
				*createstringarray 4 "HM_REAL_VALUES_E_OPTION " "HM_NODEELEMS_SET_COMPRESS_SKIP " "EXPORT_SYSTEM_LONGFORMAT " \
				  "HMBOMCOMMENTS_XML"
				set template [hm_info -appinfo SPECIFIEDPATH TEMPLATES_DIR]
				*feoutputwithdata "$template/feoutput/nastran/general" "$output_folder/$name/$name_plot" 0 0 0 1 4
				set plot_file "$output_folder/$name/$name_plot"
				set readfile_plot [open $plot_file r]
				set lines_plot [read $readfile_plot]
				set list_line_plot [split $lines_plot "\n"]
				set cord2r_plot [lsearch $list_line_plot "CORD2R*"]
				if {$cord2r_plot != -1 } {
					set m $cord2r_plot
				} else {
					set m [lsearch $list_line_plot "$$  GRID Data"]
				}
				if {$m != -1} {
					set newline1_plot [lreplace $list_line_plot 0 [expr $m-1]]
				} else {
					set newline1_plot $list_line_plot
				}
				set n [lsearch $newline1_plot "ENDDATA*"]
				if {$n != -1} {
					set newline_plot [lreplace $newline1_plot $n end]
				} else {
					set newline_plot $newline1_plot
				}
				close $readfile_plot
				set newline_plot [lremove -all $newline_plot [list {}]]
				set writefile_plot [open $plot_file w]
				puts $writefile_plot [join $newline_plot "\n"]
				close $writefile_plot
			}
		}
	}
} 

#dat lai name cho cac loadcol
proc rename_force_sei {assem} {
	puts "Run rename_force_sei"
	puts "------------------"
	foreach ass $assem {
		set assy_name [lindex $ass 0]
		if {$assy_name == "SEI" || $assy_name == "TA"} {
			set name [lindex $ass 2]
			if {$name == "" || $name == "è§£æžãƒ•ã‚©ãƒ«ãƒ€å"} {
				continue
			}
			set bango [lindex $ass 1]
			set mat10 [lindex $ass 3]
			set mat11 [lindex $ass 4]
			set mat12 [lindex $ass 5]
			set spcs [lindex $ass 6]
			set forcs [lindex $ass 7]
			set i 0
			foreach spc $spcs {
				set spc [split $spc "/"]
				eval *createmark loadcols 1 "by id only" $spc
				set spc_check [hm_getmark loadcols 1]
				foreach sp $spc_check {
					*createmark loadcols 2 "by id only" "$sp"
					set spc_check [hm_getmark loadcols 2]
					if {! [Null spc_check]} {
						set name_spc $bango\-SPC_$i
						*setvalue loadcols id=$sp name=$name_spc
						set i [expr $i+1]
					}
					*clearmark loadcols 2
				} 
			} 
			set j 0
			foreach force $forcs {
				set force [split $force "/"]
				eval *createmark loadcols 1 "by id only" $force
				set force_check [hm_getmark loadcols 1]
				foreach forc $force_check { 
					*createmark loadcols 2 "by id only" "$forc"
					set force [hm_getmark loadcols 2]
					if {! [Null force]} {
						set name_force $bango\-FORCE_$j
						*setvalue loadcols id=$force name=$name_force
						set j [expr $j + 1]
					}
					*clearmark loadcols 2
				}
			}	
		} 
	} 
}

#tao luc moment cho cac node voi vecto luc cho truoc
proc create_moment {moment} {
	puts "Run create_moment"
	puts "------------------"
	foreach ass $moment {
		set moment_id [lindex $ass 0]
		set node_id [lindex $ass 1]
		set mag_moment [lindex $ass 5]
		set moment_x [lindex $ass 2]
		set moment_y [lindex $ass 3]
		set moment_z [lindex $ass 4]
		if {$moment_id == ""} {
			break
		}
		set x [expr $moment_x * $mag_moment]
		set y [expr $moment_y * $mag_moment]
		set z [expr $moment_z * $mag_moment]
		*createmark loadcols 2 "by id only" "$moment_id"
		set loadcols_check [hm_getmark loadcols 2]
		if {! [ Null loadcols_check]} {
			set name_loadcols [hm_getvalue loadcols id=$moment_id dataname=name]
			*currentcollector loadcols "$name_loadcols"
			*loadtype 2 1
			*loadsize 1 100 0 1
			*createmark nodes 1 $node_id
			*loadcreateonentity_curve nodes 1 2 1 $x $y $z $x $y $z 0 0 0 0 0
		} else {
			*createentity loadcols id=$moment_id name = "$moment_id" 
			*loadtype 2 1
			*loadsize 1 100 0 1
			*createmark nodes 1 $node_id
			*loadcreateonentity_curve nodes 1 2 1 $x $y $z $x $y $z 0 0 0 0 0
		}
		*clearmark loadcols 2
	}
}

#gan luc len cac node cho truoc voi vecto cho truoc
proc create_force {force} { 
	puts "Run create_force"
	puts "------------------"
	foreach loadcols $force {
		set last_idloads [hm_latestentityid loadcols]
		set load_id [lindex $loadcols 0]
		set node_id [lindex $loadcols 1]
		if {$node_id == ""} {
			break
		}
		set magnitude [lindex $loadcols 5]
		set direction_x [lindex $loadcols 2]
		set direction_y [lindex $loadcols 3]
		set direction_z [lindex $loadcols 4]
		set x [expr $direction_x * $magnitude]
		set y [expr $direction_y * $magnitude]
		set z [expr $direction_z * $magnitude]
		*createmark loadcols 2 "by id only" "$load_id"
		set loadcols_check [hm_getmark loadcols 2]
		if {! [ Null loadcols_check]} {
			set name_loadcols [hm_getvalue loadcols id=$load_id dataname=name]
			*currentcollector loadcols "$name_loadcols"
			*loadsize 1 100 0 1
			*createmark nodes 1 $node_id
			*loadcreateonentity_curve nodes 1 1 1 $x $y $z $x $y $z 0 0 0 0 0
		} else {
			*createentity loadcols id=$load_id name = "$load_id" 
			*loadsize 1 100 0 1
			*createmark nodes 1 $node_id
			*loadcreateonentity_curve nodes 1 1 1 $x $y $z $x $y $z 0 0 0 0 0
		}
		*clearmark loadcols 2
	}
}

#gan luc pressure len tat ca elem cua comp
proc creat_force_comp {force_pres} {
	puts "Run creat_force_comp"
	puts "------------------"
	foreach force_comp $force_pres {
		set load_id [lindex $force_comp 0]
		set comp_id [lindex $force_comp 1]
		if {$comp_id == ""} {
			break
		}
		set magnitude [lindex $force_comp 2]
		eval *createmark elems 1 "by comps id" $comp_id
		set id_elems [hm_getmark elems 1]
		*createmark loadcols 2 "by id only" "$load_id"
		set loadcols_check [hm_getmark loadcols 2]
		if {! [ Null loadcols_check]} {
			set name_loadcols [hm_getvalue loadcols id=$load_id dataname=name]
			*currentcollector loadcols "$name_loadcols"
			# *loadsize 1 100 0 1
			*loadtype 4 1
			eval *createmark elements 1 $id_elems
			*createmark nodes 1
			*pressuresonentity_curve elements 1 1 0 0 0 $magnitude 30 1 0 0 0 0 0
		} else {
			*createentity loadcols id=$load_id name = "$load_id" 
			# *loadsize 1 100 0 1
			*loadtype 4 1
			eval *createmark elements 1 $id_elems
			*createmark nodes 1
			*pressuresonentity_curve elements 1 1 0 0 0 $magnitude 30 1 0 0 0 0 0
		}
		*clearmark loadcols 2
	}
}

#gan SPC cho cac node cho truoc voi cac dof cho truoc
proc create_spc {spc_node} { 
	puts "Run create_spc"
	puts "------------------"
	foreach loadcols $spc_node {
		set last_idload [hm_latestentityid loadcols]
		set spc_id_node [lindex $loadcols 0]
		set node_id1 [lindex $loadcols 1]
		if {$node_id1 ==""} {
			break
		}
		set dof1_x [lindex $loadcols 2]
		set dof1_y [lindex $loadcols 3]
		set dof1_z [lindex $loadcols 4]
		set dof1_rx [lindex $loadcols 5]
		set dof1_ry [lindex $loadcols 6]
		set dof1_rz [lindex $loadcols 7]
		*createmark loadcols 2 "by id only" "$spc_id_node"
		set spc [hm_getmark loadcols 2]
		if {! [Null spc]} {
			set name_loadcols [hm_getvalue loadcols id=$spc_id_node dataname=name]
			*currentcollector loadcols "$name_loadcols"
			*loadsize 1 100 0 1
			*createmark nodes 1 $node_id1
			*loadcreateonentity_curve nodes 1 3 1 $dof1_x $dof1_y $dof1_z $dof1_rx $dof1_ry $dof1_rz 0 0 0 0 0
		} else {
			*createentity loadcols id=$spc_id_node name = "$spc_id_node" 
			*loadsize 1 100 0 1
			*createmark nodes 1 $node_id1
			*loadcreateonentity_curve nodes 1 3 1 $dof1_x $dof1_y $dof1_z $dof1_rx $dof1_ry $dof1_rz 0 0 0 0 0
		}
		*clearmark loadcols 2
	}
}

#gan SPC rieng biet cho E77 - SPC co the di chuyen 1 khoang
proc create_spc_e77 {e77} {
	puts "Run create_spc_e77"
	puts "------------------"
	set name_load ""
	set node_check 0
	foreach datas $e77 {
		set spc_id [lindex $datas 0]
		if {[string is double -strict $spc_id]==0} {
			set name_load $spc_id
			set comid [lindex $datas 1]
			set nodeid [lindex $datas 2]
			if {$nodeid ==""} {
				set node_check 1
				*createmark loadcols 2 "by name only" "$spc_id"
				set loadcols_check [hm_getmark loadcols 2]
				if {! [ Null loadcols_check]} {
					*currentcollector loadcols "$spc_id"
				} else {
					*createentity loadcols name="$spc_id"
				}
			} else {
				set node_check 0
				set x_node [hm_getvalue nodes id=$nodeid dataname=x]
				set y_node [hm_getvalue nodes id=$nodeid dataname=y]
				set rangeX [lindex $datas 3]
				set rangeY [lindex $datas 4]
				eval *createmark nodes 1 "by comps id" $comid
				set node_comp_ids [hm_getmark nodes 1]
				set list_node_id []
				foreach node_id $node_comp_ids {
					set x [hm_getvalue nodes id=$node_id dataname=x]
					set y [hm_getvalue nodes id=$node_id dataname=y]
					if {$x <= [expr $x_node + $rangeX] && $x >=$x_node && $y <= [expr $y_node + $rangeY] && $y >= $y_node} {
						lappend list_node_id $node_id
					}
				}
				
				set list_node_id [loc_node_1D $list_node_id]
				# puts [llength $list_node_id]
				*createmark loadcols 2 "by name only" "$spc_id"
				set loadcols_check [hm_getmark loadcols 2]
				if {! [ Null loadcols_check]} {
					*currentcollector loadcols "$spc_id"
					*loadsize 1 100 0 1
					eval *createmark nodes 1 $list_node_id
					*loadcreateonentity_curve nodes 1 3 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0
				} else {
					*createentity loadcols name="$spc_id"
					*loadsize 1 100 0 1
					eval *createmark nodes 1 $list_node_id
					*loadcreateonentity_curve nodes 1 3 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0
				}
			}
		} else {
			set nodeid [lindex $datas 2]
			set dofx [lindex $datas 5]
			set dofy [lindex $datas 6]
			set dofz [lindex $datas 7]
			*createmark loadcols 2 "by name only" $spc_id
			set loadcols_check [hm_getmark loadcols 2]
			if {! [ Null loadcols_check]} {
				*currentcollector loadcols "$spc_id"
				*loadsize 1 100 0 1
				*createmark nodes 1 $nodeid
				*loadcreateonentity_curve nodes 1 3 1 $dofx $dofy $dofz -999999 -999999 -999999 0 0 0 0 0
			} else {
				*createentity loadcols id=$spc_id name=$spc_id
				*createmark loads 1 "by loadcols name" $name_load
				if {$node_check == 0} {
				*copymark loads 1 "$spc_id"
				}
				*loadsize 1 100 0 1
				*createmark nodes 1 $nodeid
				*loadcreateonentity_curve nodes 1 3 1 $dofx $dofy $dofz -999999 -999999 -999999 0 0 0 0 0
			}
		}
	 }
	 foreach datas $e77 {
		set spc_id [lindex $datas 0]
		*createmark loadcols 2 "by name only" "$spc_id"
		set loadcols_check [hm_getmark loadcols 2]
		if {[string is double -strict $spc_id]==0 && ![ Null loadcols_check]} {
			*createmark loadcols 1
			*clearmark loadcols 1
			*createmark loadcols 1 "$spc_id"
			*deletemark loadcols 1
		}
	 } 
}

#gan SPC cho 1 khoang range tien ve phia truoc
proc create_spc_range {spc_range} {
	puts "Run create_spc_range"
	puts "------------------"
	foreach spc $spc_range {
		set spc_id [lindex $spc 0]
		set node_id [lindex $spc 1]
		if {$node_id ==""} {
			break
		}
		set bu [lindex $spc 2]
		set range [lindex $spc 3]
		set dof2_x [lindex $spc 4]
		set dof2_y [lindex $spc 5]
		set dof2_z [lindex $spc 6]
		set dof2_rx [lindex $spc 7]
		set dof2_ry [lindex $spc 8]
		set dof2_rz [lindex $spc 9]
		set x [hm_getvalue nodes id=$node_id dataname=x]
		set nodes [hm_entitylist nodes id]
		set node_spc []
		if {$bu == "All"} {
			foreach node $nodes {
				set x_coord [hm_getvalue nodes id=$node dataname=x]
				set z_coord [hm_getvalue nodes id=$node dataname=z]
				if {$x_coord <= [expr $x] && $x_coord >= [expr $x - $range] } {
					lappend node_spc $node
				}
			}
		}
		if {$bu == "Up"} {
			foreach node $nodes {
				set x_coord [hm_getvalue nodes id=$node dataname=x]
				set z_coord [hm_getvalue nodes id=$node dataname=z]
				if {$x_coord <= [expr $x] && $x_coord >= [expr $x - $range] && $z_coord >= 250} {
					lappend node_spc $node
				}
			}
		}
		if {$bu == "Down"} {
			foreach node $nodes {
				set x_coord [hm_getvalue nodes id=$node dataname=x]
				set z_coord [hm_getvalue nodes id=$node dataname=z]
				if {$x_coord <= [expr $x] && $x_coord >= [expr $x - $range] && $z_coord <= 250} {
					lappend node_spc $node
				}
			}
		}
		
		set node_spc [loc_node_1D $node_spc]
		*createmark loadcols 2 "by id only" $spc_id
		set spc [hm_getmark loadcols 2]
		if {! [Null spc]} {
			set name_loadcols [hm_getvalue loadcols id=$spc_id dataname=name]
			*currentcollector loadcols "$name_loadcols"
			*loadsize 1 100 0 1
			eval *createmark nodes 1 $node_spc
			*loadcreateonentity_curve nodes 1 3 1 $dof2_x $dof2_y $dof2_z $dof2_rx $dof2_ry $dof2_rz 0 0 0 0 0
		} else {
			*createentity loadcols id=$spc_id name = $spc_id 
			*loadsize 1 100 0 1
			eval *createmark nodes 1 $node_spc
			*loadcreateonentity_curve nodes 1 3 1 $dof2_x $dof2_y $dof2_z $dof2_rx $dof2_ry $dof2_rz 0 0 0 0 0
		}
		*clearmark loadcols 2
	}
}

#func loc node 1D khi gan SPC or Rigid
proc loc_node_1D {list_node} {
		set loadcols_all [hm_entitylist loadcols id]
		set comps_all [hm_entitylist comps id]
		eval *createmark components 2 $comps_all
		*createstringarray 2 "elements_on" "geometry_on"
		*hideentitybymark 2 1 2
		*clearmark components 2
		eval *createmark loadcols 2 $loadcols_all
		*createstringarray 2 "elements_on" "geometry_on"
		*hideentitybymark 2 1 2
		*clearmark loadcols 2
		eval *createmark nodes 1 $list_node
		*findmark nodes 1 275 1 elements 0 2
		*clearmark nodes 1
		eval *createmark elems 1 "displayed" 
		set elem_configs [hm_getmark elems 1]
		*clearmark elems 1
		foreach elem_config $elem_configs {
			set configtype [hm_getvalue elems id=$elem_config dataname=config]
			if {$configtype == 55 || $configtype == 56 || $configtype == 3 || $configtype == 208 || $configtype == 5 } {
				set node_check_1D [hm_getvalue elems id=$elem_config dataname=nodes]
				foreach node_1d $node_check_1D {
					set n [lsearch $list_node $node_1d]
					if {$n != -1} {
						set list_node [lreplace $list_node $n $n]
					}
				}
			}
		}
		return $list_node
}

#doc thong tin sheet1 excel
proc read_force {} { 
	puts "Run read_force"
	puts "------------------"
	variable gui; global glo ; global filemodel; global outputfolder; global supportfolder
	set excel_file $glo(path_fileinput)
	package require twapi
	set excel [::twapi::comobj Excel.Application]
	$excel DisplayAlerts [expr 0]
	set workbooks [$excel Workbooks]
	$workbooks Open "$excel_file"
	set workbook [$workbooks Item 1]
	set sheets [$workbook Sheets]
	set sheet [$sheets Item 2]
	set cells [$sheet Cells]
	# read force node
	set list_force []
	set load_id ""
	for {set i 7} {$i < 100} {incr i} {
		if {[[$sheet range c$i] Value] == ""} {
			break
		}
		set list []
		if {[[$sheet range b$i] Value] != ""} {
			set load_id [[$sheet range b$i] Value]
		}
		set node_id [[$sheet range c$i] Value]
		if {[[$sheet range d$i] Value] == "O"} {
			set direction_x 1
		} else {
			set direction_x 0
		}
		if {[[$sheet range e$i] Value] == "O"} {
			set direction_y  1
		} else {
			set direction_y  0
		}
		if {[[$sheet range f$i] Value] == "O"} {
			set direction_z  1
		} else {
			set direction_z  0
		}
		set magnitude [[$sheet range g$i] Value]
		lappend list $load_id
		lappend list $node_id
		lappend list $direction_x
		lappend list $direction_y
		lappend list $direction_z
		lappend list $magnitude
		
		lappend list_force $list
	}
	# force presure
	set list_force_comp []
	set load_id_comp ""
	for {set i 7} {$i < 100} {incr i} {
		if {[[$sheet range L$i] Value] == ""} {
			break
		}
		set list_comp []
		if {[[$sheet range K$i] Value] != ""} {
			set load_id_comp [[$sheet range K$i] Value]
		}
		set comp_id [[$sheet range L$i] Value]
		set comp_id [split $comp_id "/"]
		set magnitude_comp [[$sheet range m$i] Value]
		lappend list_comp $load_id_comp
		lappend list_comp $comp_id
		lappend list_comp $magnitude_comp
		
		lappend list_force_comp $list_comp
	}
	
	# read SPC NODE
	set spc_node []
	set spc_id_node ""
	for {set i 7} {$i < 100} {incr i} {
		if {[[$sheet range r$i] Value] == ""} {
			break
		}
		set spc1 []
		if {[[$sheet range q$i] Value] != ""} {
			set spc_id_node [[$sheet range q$i] Value]
		}
		set node_id1 [[$sheet range r$i] Value]

		if {[[$sheet range s$i] Value] == "O"} {
			set dof1_x 0
		} else {
			set dof1_x -999999
		}
		if {[[$sheet range t$i] Value] == "O"} {
			set dof1_y 0
		} else {
			set dof1_y -999999
		}
		if {[[$sheet range u$i] Value] == "O"} {
			set dof1_z 0
		} else {
			set dof1_z -999999
		}
		if {[[$sheet range v$i] Value] == "O"} {
			set dof1_rx 0
		} else {
			set dof1_rx -999999
		}
		if {[[$sheet range w$i] Value] == "O"} {
			set dof1_ry 0
		} else {
			set dof1_ry -999999
		}
		if {[[$sheet range x$i] Value] == "O"} {
			set dof1_rz 0
		} else {
			set dof1_rz -999999
		}
		lappend spc1 $spc_id_node
		lappend spc1 $node_id1
		lappend spc1 $dof1_x
		lappend spc1 $dof1_y
		lappend spc1 $dof1_z
		lappend spc1 $dof1_rx
		lappend spc1 $dof1_ry
		lappend spc1 $dof1_rz
		
		lappend spc_node $spc1
	}
	
	# read SPC Range
	set spc_range []
	set spc_id_range ""
	for {set i 7} {$i < 100} {incr i} {
		if {[[$sheet range ac$i] Value] == ""} {
			break
		}
		set spc2 []
		if {[[$sheet range ab$i] Value] != ""} {
			set spc_id_range [[$sheet range ab$i] Value]
		}
		set node_id2 [[$sheet range ac$i] Value]
		set set_id [[$sheet range ad$i] Value]
		set range [[$sheet range ae$i] Value]
		if {[[$sheet range af$i] Value] == "O"} {
			set dof2_x 0
		} else {
			set dof2_x -999999
		}
		if {[[$sheet range ag$i] Value] == "O"} {
			set dof2_y 0
		} else {
			set dof2_y -999999
		}
		if {[[$sheet range ah$i] Value] == "O"} {
			set dof2_z 0
		} else {
			set dof2_z -999999
		}
		if {[[$sheet range ai$i] Value] == "O"} {
			set dof2_rx 0
		} else {
			set dof2_rx -999999
		}
		if {[[$sheet range aj$i] Value] == "O"} {
			set dof2_ry 0
		} else {
			set dof2_ry -999999
		}
		if {[[$sheet range ak$i] Value] == "O"} {
			set dof2_rz 0
		} else {
			set dof2_rz -999999
		}
		lappend spc2 $spc_id_range
		lappend spc2 $node_id2
		lappend spc2 $set_id
		lappend spc2 $range
		lappend spc2 $dof2_x
		lappend spc2 $dof2_y
		lappend spc2 $dof2_z
		lappend spc2 $dof2_rx
		lappend spc2 $dof2_ry
		lappend spc2 $dof2_rz

		lappend spc_range $spc2
	}
	#read gotail b09
	set gotai_b09 []
	set pid_cog ""
	
	for {set i 7} {$i < 100} {incr i} {
		if {[[$sheet range ao$i] Value] == ""} {
			break
		}
		set gotai []
		if {[[$sheet range ao$i] Value] != ""} {
			set pid_cog [[$sheet range ao$i] Value]
		}
		set comp_id_b09 [[$sheet range ap$i] Value]
		set comp_id_b09 [split $comp_id_b09 "/"]
		lappend gotai $pid_cog
		lappend gotai $comp_id_b09
		
		lappend gotai_b09 $gotai
	}
	#read e77 
	set list_e77 []
	set spc_id_e77 ""
	for {set i 7} {$i < 100} {incr i} {
		if {[[$sheet range av$i] Value] == ""} {
			break
		}
		set list_e77_check []
		if {[[$sheet range at$i] Value] != ""} {
			set spc_id_e77 [[$sheet range at$i] Value]
		}
		set comp_id_e77 [[$sheet range au$i] Value]
		set comp_id_e77 [split $comp_id_e77 "/"]
		set node_id_e77 [[$sheet range av$i] Value]
		set rangeX [[$sheet range aw$i] Value]
		set rangeY [[$sheet range ax$i] Value]
		if {[[$sheet range ay$i] Value] == "O"} {
			set dofe77_x 1
		} else {
			set dofe77_x -999999
		}
		if {[[$sheet range az$i] Value] == "O"} {
			set dofe77_y 1
		} else {
			set dofe77_y -999999
		}
		if {[[$sheet range ba$i] Value] == "O"} {
			set dofe77_z 1
		} else {
			set dofe77_z -999999
		}
		lappend list_e77_check $spc_id_e77
		lappend list_e77_check $comp_id_e77
		lappend list_e77_check $node_id_e77
		lappend list_e77_check $rangeX
		lappend list_e77_check $rangeY
		lappend list_e77_check $dofe77_x
		lappend list_e77_check $dofe77_y
		lappend list_e77_check $dofe77_z
		
		lappend list_e77 $list_e77_check
	}
	set find_monent 7
	for {set i 7} {$i < 100} {incr i} {
		set find_monent [expr $find_monent + 1]
		if {[[$sheet range b$i] Value] == "MOMENT"} {
			break
		}
	}
	set list_moment []
	set moment_id ""
	for {set i $find_monent} {$i < 100} {incr i} {
		if {[[$sheet range c$i] Value] == ""} {
			break
		}
		set list_moment_check []
		if {[[$sheet range b$i] Value] != ""} {
			set moment_id [[$sheet range b$i] Value]
		}
		set node_moment_id [[$sheet range c$i] Value]
		if {[[$sheet range d$i] Value] == "O"} {
			set moment_x 1
		} else {
			set moment_x 0
		}
		if {[[$sheet range e$i] Value] == "O"} {
			set moment_y  1
		} else {
			set moment_y  0
		}
		if {[[$sheet range f$i] Value] == "O"} {
			set moment_z  1
		} else {
			set moment_z  0
		}
		set mag_moment [[$sheet range g$i] Value]
		lappend list_moment_check $moment_id
		lappend list_moment_check $node_moment_id
		lappend list_moment_check $moment_x
		lappend list_moment_check $moment_y
		lappend list_moment_check $moment_z
		lappend list_moment_check $mag_moment
		
		lappend list_moment $list_moment_check
	}
	set list_node_local []
	for {set i 7} {$i < 100} {incr i} {
		if {[[$sheet range bd$i] Value] == ""} {
			break
		}
		set list_local []
		set node_local [[$sheet range bd$i] Value]
		if {[[$sheet range be$i] Value] == "O"} {
			set forcex "01.0     1.0     0.0     0.0"
		} else {
			set forcex 0
		}
		if {[[$sheet range bf$i] Value] == "O"} {
			set forcey "01.0     0.0     1.0     0.0"
		} else {
			set forcey 0
		}
		if {[[$sheet range bg$i] Value] == "O"} {
			set forcez "01.0     0.0     0.0     1.0"
		} else {
			set forcez 0
		}
		if {[[$sheet range bh$i] Value] == "O"} {
			set force_x "01.0    -1.0     0.0     0.0"
		} else {
			set force_x 0
		}
		if {[[$sheet range bi$i] Value] == "O"} {
			set force_y "01.0    0.0     -1.0     0.0"
		} else {
			set force_y 0
		}
		if {[[$sheet range bj$i] Value] == "O"} {
			set force_z "01.0     0.0     0.0    -1.0"
		} else {
			set force_z 0
		}
		
		lappend list_local $node_local
		lappend list_local $forcex
		lappend list_local $force_x
		lappend list_local $forcey
		lappend list_local $force_y
		lappend list_local $forcez	
		lappend list_local $force_z
		lappend list_node_local $list_local
	}
	
	set id_b09 []

	set load_ids [[$sheet range AP5] Value]
	set load_id [split $load_ids "/"]
	lappend id_b09 $load_id
	
	set data_cdh []
	for {set i 7} {$i < 100} {incr i} {
		if {[[$sheet range bl$i] Value] == ""} {
			break
		}
		set cdh []
		set mats [[$sheet range bl$i] Value]
		set young [[$sheet range bM$i] Value]
		lappend cdh $mats
		lappend cdh $young
		lappend data_cdh $cdh
	}
	
	
	set read_excel []
	lappend read_excel $list_force
	lappend read_excel $list_force_comp
	lappend read_excel $spc_node
	lappend read_excel $spc_range
	lappend read_excel $gotai_b09
	lappend read_excel $list_e77
	lappend read_excel $list_moment
	lappend read_excel $list_node_local
	lappend read_excel $id_b09
	lappend read_excel $data_cdh
	
	
	$excel Quit
	$cells -destroy
	$sheet -destroy
	$sheets -destroy
	$workbook -destroy
	$workbooks -destroy
	$excel -destroy
	unset excel
	return $read_excel
	
}

#doc thong tin sheet1 excel
proc read_assem {} {
	puts "Run read_assem"
	puts "------------------"
	variable gui; global glo ; global filemodel; global outputfolder; global supportfolder
	set excel_file $glo(path_fileinput)
	package require twapi
	set excel [::twapi::comobj Excel.Application]
	$excel DisplayAlerts [expr 0]
	set workbooks [$excel Workbooks]
	$workbooks Open "$excel_file"
	set workbook [$workbooks Item 1]
	set sheets [$workbook Sheets]
	set sheet [$sheets Item 1]
	set cells [$sheet Cells]
	
	set sum_colum [list M N O P Q R S T U V W X Y Z AA AB AC AD AE AF AG AH AI AK AL AM AN AO AP AQ AR AS AT AU AV AW AX AY AZ BA BB BC BD BE BF BG BH BI BJ BK BL BM BN BO BP BQ BR BS BU BV BÆ¯ BX BY BZ]
	set colum_ass []
	set colum_ass []
	set colum_comp []
	set colum_plot []
	set check_ass ""
	set l_ass 1
	set l_ass1 2
	foreach cl $sum_colum {
		if {[[$sheet range $cl$l_ass1] Value] == ""} {
			break
		}
		if {[[$sheet range $cl$l_ass] Value] != "" } {
			set check_ass [[$sheet range $cl$l_ass] Value]
		}
		if {$check_ass == "ASSEM" } {
			lappend colum_ass $cl
		}
		if {$check_ass == "COMP" } {
			lappend colum_comp $cl
		}
		if {$check_ass == "PLOTEL" } {
			lappend colum_plot $cl
		}
	}

	set row 4
	for {set i 4} {$i < 1000} {incr i} { 
		set row [expr $row +1]
		if {[[$sheet range a$i] Value] == "TA"} {
			break
		}
	}
	set rows $row
	for {set i $row} {$i < 1000} {incr i} { 
		if {[[$sheet range c$i] Value] == ""} {
			break
		}
		set rows [expr $rows +1]
	}
	set assem []
	set kei_name ""
	for {set i 4} {$i < $rows} {incr i} {
		set sub_asem [] 
		if { [[$sheet range a$i] Value] != "" } {
			set kei_name [[$sheet range a$i] Value]
		}
		set bango [[$sheet range b$i] Value]
		set name [[$sheet range c$i] Value]
		set mat10 [[$sheet range d$i] Value]
		set mat11 [[$sheet range e$i] Value]
		set mat12 [[$sheet range f$i] Value]	
		set spc [[$sheet range g$i] Value]
		set spc [split $spc "/"]
		set force [[$sheet range h$i] Value]
		set force [split $force "/"]
		set node_local [[$sheet range I$i] Value]
		set node_local [split $node_local "/"]
		set node_global [[$sheet range J$i] Value]
		set node_global [split $node_global "/"]
		set tanso [[$sheet range L$i] Value]
		set dat_data [[$sheet range K$i] Value]
		
		lappend sub_asem $kei_name
		lappend sub_asem $bango
		lappend sub_asem $name
		lappend sub_asem $mat10
		lappend sub_asem $mat11
		lappend sub_asem $mat12
		lappend sub_asem $spc
		lappend sub_asem $force
		lappend sub_asem $node_local
		lappend sub_asem $node_global
		lappend sub_asem $dat_data
		lappend sub_asem $tanso
		set id_set_maru []
		set id_set_batu []
		
		set a 2
		foreach j $colum_ass {
			set check_ass ""
			 if {[[$sheet range $j$i] Value] == "ã€‡"} {
				 set check_ass [[$sheet range $j$a] Value]
				 lappend id_set_maru $check_ass
			 }
			 if {[[$sheet range $j$i] Value] == "âœ–"} {
				 set check_ass [[$sheet range $j$a] Value]
				 lappend id_set_batu $check_ass
			 }
		}
		lappend sub_asem $id_set_maru
		lappend sub_asem $id_set_batu
		set id_comp []
		foreach j $colum_comp {
			set check_comp ""
			if {[[$sheet range $j$i] Value] == "ã€‡"} {
				set check_comp [[$sheet range $j$a] Value]
				lappend id_comp $check_comp
			 }
		}
		lappend sub_asem $id_comp
		
		set id_plot []
		foreach j $colum_plot {
			set check_plot ""
			if {[[$sheet range $j$i] Value] == "ã€‡"} {
				set check_plot [[$sheet range $j$a] Value]
				lappend id_plot $check_plot
			 }
		}
		lappend sub_asem $id_plot

		lappend assem $sub_asem
	}
	
	set matid1 [[$sheet range d2] Value]
	set matid2 [[$sheet range e2] Value]
	set matid3 [[$sheet range f2] Value]
	set list_mat [list $matid1 $matid2 $matid3]
	set assem_all [list $assem $list_mat]
	$excel Quit
	$cells -destroy
	$sheet -destroy
	$sheets -destroy
	$workbook -destroy
	$workbooks -destroy
	$excel -destroy
	unset excel
	return $assem_all
}

#goi main
::NTV::main_GUI

	log $end
}

proc log {comment} {
	after 1000
	global tcl_platform
	set log ""
	set link_folder_log "//vn-ntv-fs003cae/GK0/GK210/02_MACRO-DATA/LogFile/HyperMesh-Macro"
	
	#sua ten folder tuong uong voi ten tool
	set tool_name "00_Kyoukai_1st"  
	
	file mkdir "$link_folder_log/$tool_name"
	set date [clock format [clock seconds] -format "%Y_%m_%d"]
	set time [clock format [clock seconds] -format "%H_%M_%S"]
	
	set year [string range $date 0 3]
	set month [string range $date 5 6]
	set day [string range $date 8 9]
	set hh [string range $time 0 1]
	set mm [string range $time 3 4]
	set ss [string range $time 6 7]


	set file_name "$date\_$time $tool_name\_$comment\_$tcl_platform(user).csv"
	set time_start "$year\/$month\/$day $hh\:$mm\:$ss"
	set knt $tcl_platform(user)
	set host_name [info hostname]
	set id_host [string range $host_name 0 1]
	if {[string toupper $id_host] == "VN"} {
		set pos "NATV"
	} elseif {[string toupper $id_host] == "JP"} {
		set pos "NAT"
	} else {
		set pos "other"
	}

	set log "$time_start\,$pos\,$knt\,$tool_name,$tool_name\.tcl,Efficiency,Model making,$comment\,NULL,NULL"
	set file_log "$link_folder_log/$tool_name/$file_name"
	if {[file exists $file_log]== 0} {
		close [open $file_log w]
	}
	
	set writefile [open $file_log w]
	puts $writefile $log
	close $writefile
}

main
