
# # Update 2024/09/06 - BT.Kien - FindHoleNodesAndFlangeNodes
# # Update 2024/08/29 - BT.Kien - FindHoleNodesAndFlangeNodes
# # Update 2024/10/13 - BT.Kien - BeamSolid
# # Update 2024/11/26 - BT.Kien - BeamSolid: add func CheckNormalAndReserve


namespace eval ::NTV {} {}

#thiet lap giao dien
proc ::NTV::main_GUI {} {
	global glo ; global filemodel; global outputfolder; global supportfolder , base
	set base .tool1;
	toplevel $base;
	::hwt::KeepOnTop $base
	wm attribute $base -toolwindow 0
	wm title $base "MASTER ì¬";
	wm geometry $base 500x175;
	set master_frame [frame $base.master_frame];
	pack $master_frame -side top -anchor nw -padx 7 -pady 7 -expand 1 -fill both;

	set gui(f1) [frame $master_frame.f1]
	pack $gui(f1) -side top -padx 2 -pady 2 -expand 0 -fill x
	
		set gui(f1_open_model) [frame $gui(f1).f1_open_model]
		pack $gui(f1_open_model) -side top -padx 2 -pady 2 -expand 0 -fill x
		
			set gui(ent_open_model) [entry $gui(f1_open_model).ent_open_model -textvariable glo(path_fileinput)]
			pack $gui(ent_open_model) -side left -padx 0 -pady 0 -expand 1 -fill x 
		
			set gui(but_open_model) [button $gui(f1_open_model).but_open_model -text "File Excel" -width 12 -command "::NTV::open_file fileinput" ]
			pack $gui(but_open_model) -side left -padx 0 -pady 0 -fill y
			
		set gui(frame2) [frame $gui(f1).frame2]
		pack $gui(frame2) -side top -padx 0 -pady 5 -expand 0 -fill x
			set gui(check1) [checkbutton $gui(frame2).check1 -text "BEAM->SOLID" -variable glo(solid) -font {{Arial} 7 bold}]
			pack $gui(check1) -side left -padx 0 -pady 4
			
			set gui(check2) [checkbutton $gui(frame2).check2 -text "BEAM->BEAM" -variable glo(beam) -font {{Arial} 7 bold}]
			pack $gui(check2) -side left -padx 50 -pady 4
			
			set gui(check3) [checkbutton $gui(frame2).check3 -text "Assembly " -variable glo(assem) -font {{Arial} 7 bold}]
			pack $gui(check3) -side left -padx 40 -pady 4
			
		set gui(frame3) [frame $gui(f1).frame3]
		pack $gui(frame3) -side top -padx 0 -pady 0 -expand 0 -fill x	
			set gui(check4) [checkbutton $gui(frame3).check4 -text "GOTAIL & RENUMBER" -variable glo(renumber) -font {{Arial} 7 bold}]
			pack $gui(check4) -side left -padx 0 -pady 4
			
			set gui(check5) [checkbutton $gui(frame3).check5 -text "PLOTED" -variable glo(ploted) -font {{Arial} 7 bold}]
			pack $gui(check5) -side left -padx 34 -pady 4
			
			set gui(check6) [checkbutton $gui(frame3).check6 -text "MODEL CUT	" -variable glo(cutmodel) -font {{Arial} 7 bold}]
			pack $gui(check6) -side left -padx 50 -pady 4
			
			set glo(beam) 1
			set glo(solid) 1
			set glo(assem) 1
			set glo(renumber) 1
			set glo(ploted) 1
			set glo(cutmodel) 1
			
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

proc Run {} {
	variable gui; global glo ;global input
	variable base
	set input $glo(path_fileinput)
	# set folderPath "C:/Users/KNT20993/Desktop/FY24/2.GK210_BIW/P33C/Base/P33C-ePWR"
	set inputsheet [read_input_sheet4]
	set renumber_node_data [lindex $inputsheet 0]
	set gotail_settei [lindex $inputsheet 1]
	set list_ass [lindex $inputsheet 2]
	set list_plot [lindex $inputsheet 3]
	set folder_cut [lindex $inputsheet 4]
	
	set inputsheet_link [read_input_sheet3]
	set folderPath [lindex $inputsheet_link 0]
	set ansa_ver [lindex $inputsheet_link 1]
	set output_name [lindex $inputsheet_link 2]
	set support_folder [lindex $inputsheet_link 3]
	set op_cb [lindex $inputsheet_link 4]
	
	
	if {$glo(assem)} {
		puts "ASSEMBLY"
		puts "--------------"
		set inclue_all [readFilesAndFolders $folderPath]
		create_ass $inclue_all $list_ass
	}
	
	### --- shashi beam -----
	if {$glo(beam)} {
		puts "beam -> beam"
		puts "--------------"
		input_beam_shashi $support_folder
		beam_shashi
	}


	### ---- shashi solid ------
	if {$glo(solid)} {
		puts "beam -> solid"
		puts "--------------"
		solid_shashi $support_folder
	}
	
	
	### user include bang tay
	### # create_incule $inclue_all
	
	
	##### ---- code
	if {$glo(renumber)} {
		puts "create gotail and Renumber"
		puts "--------------"
		create_gotail $support_folder
		set op_renumber [renumber_node $support_folder]
		output_renumber $op_renumber
	}

	if {$glo(ploted)} {
		puts "create PLOT"
		puts "--------------"
		create_plot $list_plot
	}
	
	export_master $output_name $folderPath
	if {$glo(cutmodel)} {
		puts "CUT MODEL"
		puts "--------------"
		output_cut_model $output_name $folder_cut $op_cb $folderPath
		run_ansa $ansa_ver $support_folder
		cdh_CB $folder_cut $op_cb
	}
	
	tk_messageBox -message "Complete"
	destroy $base
}

proc output_renumber {op_renumber} {
	global input 
	set excel_file $input
	package require twapi
	set excel [::twapi::comobj Excel.Application]
	$excel DisplayAlerts [expr 0]
	set workbooks [$excel Workbooks]
	$workbooks Open "$excel_file"
	set workbook [$workbooks Item 1]
	set sheets [$workbook Sheets]
	set sheet [$sheets Item 4]
	set cells [$sheet Cells]
	
	set i 8
	foreach item $op_renumber {
		set node [lindex $item 0]
		set dis [lindex $item 1]
		$cells Item $i B "$node"
		$cells Item $i C "NG"
		set i [expr $i + 1]
	}
	
	$workbook Save
	$workbook -destroy
	$sheets -destroy
	$sheet -destroy
	$cells -destroy
	$excel Quit
	$excel -destroy



}

proc renumber_node {support_folder} {
	
	set nodes [hm_entitylist nodes id]
	eval *createmark nodes 1 $nodes
	*renumbersolverid nodes 1 10001 1 0 0 0 0 0
	
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
	
	set file_renumber "$support_folder/renumber.nas"
	*feinputpreserveincludefiles 
	*createstringarray 13 "Nastran " "NastranMSC " "ANSA " "PATRAN " "SPC1_To_SPC " \
	  "EXPAND_IDS_FOR_FORMULA_SETS " "HM_READ_PCL_GRUPEE_COMMENTS " "ASSIGNPROP_BYHMCOMMENTS" \
	  "LOADCOLS_DISPLAY_SKIP " "VECTORCOLS_DISPLAY_SKIP " "SYSTCOLS_DISPLAY_SKIP " \
	  "CONTACTSURF_DISPLAY_SKIP " "IMPORT_MATERIAL_METADATA"
	*feinputwithdata2 "\#nastran\\nastran" $file_renumber 0 0 0 0 0 1 13 1 0
	*createmark elements 1 "displayed"
	set gotail [hm_getmark elements 1]
	# set comps_all [hm_entitylist comps id]
	# eval *createmark components 1 $comps_all
	# *equivalence components 1 0.5 1 0 0
	#### paste node gan nhat vs node renumber sanco => output ra khoang cach pates tuong ung 
	
	set gotail_renumber [lindex $gotail 0]
	set node1 [hm_getvalue elems id=$gotail_renumber dataname=node1]
	*createmark nodes 1 "by elem id" $gotail_renumber
	set node_renumber [hm_getmark nodes 1]
	*clearmark nodes 1
	set pos [lsearch -all $node_renumber $node1]
	set node_renumber [lreplace $node_renumber $pos $pos]
	set output_node []
	foreach node $node_renumber {
		set x [hm_getvalue node id=$node dataname=x]
		set y [hm_getvalue node id=$node dataname=y]
		set z [hm_getvalue node id=$node dataname=z]
		*createmark nodes 1 "by sphere" $x $y $z 5 inside 0 1 0
		set node_near [hm_getmark nodes 1]
		*clearmark nodes 1
		set pos1 [lsearch -all $node_near $node]
		set node_near [lreplace $node_near $pos1 $pos1]
		set max 100
		foreach node_c $node_near {
			set dis_check [hm_getdistance nodes $node_c $node 0]
			set r [lindex $dis_check 0]
			if {$r < $max} {
				set max $r
				set node_ok $node_c
			}
		}
		set a []
		if {$max != 100} {
			*replacenodes $node_ok $node 1 0
		} else {
			lappend a $node
			lappend a "NG"
			lappend output_node $a
		}
	}
	
	eval *createmark elems 1 $gotail
	*deletemark elems 1	
	return $output_node
}


proc output_cut_model {output_name folder_cut op_cb input_folder} {
	set list_filename [split $output_name "/"]
	set name_op [lindex $list_filename end]
	foreach cut $folder_cut {
		set folder_name [lindex $cut 0]
		set assem_rm [lindex $cut 1]
		set list_ass_rm [split $assem_rm ","]
		set comps_all [hm_entitylist comps id]
		eval *createmark components 2 $comps_all
		*createstringarray 2 "elements_on" "geometry_on"
		*showentitybymark 2 1 2
		*clearmark components 2
		
		*createmark assemblies 2 "BIW"
		*createstringarray 2 "elements_on" "geometry_on"
		*isolateentitybymark 2 1 2
		*clearmark assemblies 2
		
		set loadcols_all [hm_entitylist loadcols id]
		eval *createmark components 2 $loadcols_all
		*createstringarray 2 "elements_on" "geometry_on"
		*hideentitybymark 2 1 2
		*clearmark components 2
		
		eval *createmark assemblies 2 $list_ass_rm
		set x [hm_getmark assemblies 2]
		*createstringarray 2 "elements_on" "geometry_on"
		*hideentitybymark 2 1 2
		*clearmark assemblies 2
		
		file mkdir "$op_cb/$folder_name"
		*createstringarray 4 "HM_REAL_VALUES_E_OPTION " "HM_NODEELEMS_SET_COMPRESS_SKIP " "EXPORT_SYSTEM_LONGFORMAT " \
				  "HMBOMCOMMENTS_XML"
		hm_answernext yes
		set template [hm_info -appinfo SPECIFIEDPATH TEMPLATES_DIR]
		*feoutputwithdata "$template/feoutput/nastran/general" "$op_cb/$folder_name/$name_op" 0 0 0 1 4
		
		set files [glob -directory $input_folder -- *]
		foreach file $files {
			if {[string first ".vip" $file] != -1 } {
				set spli_vip [split $file "/"]
				set name_vip [lindex $spli_vip end]
				if {[file exists "$op_cb/$folder_name/$name_vip"] == 1} {
					continue
				} else {
					file copy $file "$op_cb/$folder_name/$name_vip"
				}
			}
		}
		
	}

}

proc cdh_CB {folder_cut op_cb} {
	puts "Run cdh_CB"
	puts "------------------"
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
	
	foreach folders $folder_cut {
		set folder [lindex $folders 0]
		set fole_master "$op_cb/$folder"
		set files [glob -directory $fole_master -- *]
		set gird 50000000
		set solid 50000000
		set rbe3 51000000
		set off 500
		foreach file $files { 
			if {[string first ".nas" $file] != -1 } {
				$cells Item 1 A ""
				$cells Item 2 A $file
			}
		}
		foreach file $files { 
			if {[string first ".vip" $file] != -1 } {
				$cells Item 3 A $file
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
					if {[string first "sptFe.hexa" $file_check] != -1 || [string first "sptFe.rbe3" $file_check] != -1} {
						set len_file [string length $file]
						set type_file [string range $file [expr $len_file-7] [expr $len_file - 5]]
						puts "===== $type_file"
						set file_hexa [string map "spt $type_file" $file_check]
						file rename $file_check $file_hexa
					}
				}
			}
		}
		
		set files_checks [glob -directory $fole_master -- *]
		foreach file_check $files_checks { 
			set len_file [string length $file_check]
			set del_name [string range $file_check [expr $len_file - 4] [expr $len_file - 1]]
			if {$del_name != ".dat" && $del_name != ".nas" && $del_name != "hexa" && $del_name != "rbe3"
				&& $del_name != ".set" && $del_name != "uset" && $del_name != ".vip"} {
					file delete -force -- $file_check
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


# #### ------ start tool solid ----------------
proc solid_shashi {support_folder} {
	# puts "Start time: [clock format [clock seconds] -format %H:%M:%S]"
	set path "$support_folder/Shashi/solid.nas"
	set path [file normalize $path]
	# # Import old model (solid model)
	ImportModel $path
	## Run beam-solid module
	BeamSolid
	# puts "End time: [clock format [clock seconds] -format %H:%M:%S]"
}

# # Update 2024/08/29 - BT.Kien - FindHoleNodesAndFlangeNodes
# # Update 2024/10/04 - BT.Kien - FindHoleNodesAndFlangeNodes
# # Update 2024/11/26 - BT.Kien - BeamSolid
# # Update 2025/01/17 - BT.Kien - BeamSolid: Move old elements into new assembly
proc BeamSolid {} {
	## Collect all assemblies
	hm_markclearall 1
	hm_markclearall 2
	*createmark assemblies 1 "all"
	set assems [hm_getmark assemblies 1]
	
	## Collect all cbeam
	hm_markclearall 1
	hm_markclearall 2
	*createmark elems 1 "by config type" 0 "bar2" "CBEAM"
	set cbeams [hm_getmark elems 1]
	foreach cbeam $cbeams {
		hm_markclearall 1
		hm_markclearall 2 
		*createmark elems 1 $cbeam
		set cbeam [hm_getmark elems 1]
		if {$cbeam == ""} {continue}
		## Find each group cbeam
		hm_markclearall 1
		hm_markclearall 2 
		*createmark elems 1 $cbeam
		set gr_cbeam [hm_getmark elems 1]
		set flag 1
		while {$flag == 1} {
			*findmark elems 1 257 1 elems 0 2
			set Founds [hm_getmark elems 2]
			set flag 0
			foreach elem $Founds {
				set elem_typename [hm_getvalue elems id=$elem dataname=typename]
				if {$elem_typename == "CBEAM"} {
					set flag 1
					lappend gr_cbeam $elem
				}
			}
			hm_markclearall 1
			hm_markclearall 2 
			eval *createmark elems 1 $gr_cbeam
		}
		
		## Find node on top and bot of cbeam group and get cbeam comp 
		variable node_bot
		hm_markclearall 1
		hm_markclearall 2
		set cbeam_nodes []
		set beam_comps []
		foreach cbeam $gr_cbeam {
			# get cbeam comp
			lappend beam_comps [hm_getvalue elems id=$cbeam dataname=collector]
			
			# get cbeam nodes
			hm_markclearall 1
			*createmark nodes 1 "by element id" $cbeam
			set cbeam_nodes [concat $cbeam_nodes [hm_getmark nodes 1]]
		}
		
		## Find assem of cbeam comps
		set b_assems []
		foreach assem $assems {
			set assem_comp [hm_getvalue assemblies id=$assem dataname=components]
			foreach bcomp $beam_comps {
				if {$bcomp in $assem_comp} {
					lappend b_assems $assem
				}
			}
		}
		set b_assems [lsort -unique $b_assems]
		
		variable node0 [lindex $cbeam_nodes 0]
		set cbeam_nodes [lsort -command compare $cbeam_nodes]
		set node_top [lindex $cbeam_nodes 0]
		variable node0 $node_top
		set cbeam_nodes [lsort -command compare $cbeam_nodes]
		set node_bot [lindex $cbeam_nodes 0]
		set dist_x [expr abs([lindex [hm_getdistance nodes  $node_top $node_bot 0] 1])]
		set dist_y [expr abs([lindex [hm_getdistance nodes $node_top $node_bot 0] 2])]
		set dist_z [expr abs([lindex [hm_getdistance nodes $node_top $node_bot 0] 3])]
		set ldist1 [list $dist_x $dist_y $dist_z]
		set ldist2 [lsort -command compare3 $ldist1]
		set maxdist [lindex $ldist2 end]
		set index [lsearch $ldist1 $maxdist]
		if {$index == 0} {set main_axis "x"}\
		elseif {$index == 1} {set main_axis "y"}\
		else {set main_axis "z"}
		
		set node1 $node_top
		set node1_po [hm_getvalue nodes id=$node1 dataname=$main_axis]
		set node2 $node_bot
		set node2_po [hm_getvalue nodes id=$node2 dataname=$main_axis]
		
		if {$node1_po<$node2_po} {
			set node_top $node2
			set node_bot $node1
		}
		## Check 3D elements
		hm_markclearall 1
		hm_markclearall 2
		set x [hm_getvalue nodes id=$node_top dataname=x]
		set y [hm_getvalue nodes id=$node_top dataname=y]
		set z [hm_getvalue nodes id=$node_top dataname=z]
		set i [hm_getvalue nodes id=$node_bot dataname=x]
		set j [hm_getvalue nodes id=$node_bot dataname=y]
		set k [hm_getvalue nodes id=$node_bot dataname=z]
		set r 5
		set h [lindex [hm_getdistance nodes $node_top $node_bot 0] 0]
		*createmark elems 1 "by cylinder" $x $y $z $i $j $k $r $h "inside" 0 1 0
		set Founds [hm_getmark elems 1]
		
		set elems_3d []
		foreach elem $Founds {
			set elem_typename [hm_getvalue elems id=$elem dataname=typename]
			if {$elem_typename == "CTETRA"} {
				lappend elems_3d $elem
			}
		}
		if {[llength $elems_3d] == 0} {
			continue
		}
		## Find new hole nodes
		hm_markclearall 1
		hm_markclearall 2 
		eval *createmark elems 1 $gr_cbeam
		*findmark elems 1 257 0 elems 0 2
		set del_elems [hm_getmark elems 2]
		hm_markclearall 1
		hm_markclearall 2 
		eval *createmark elems 1 $del_elems
		*findmark elems 1 257 0 elems 0 2
		*findmark elems 2 257 0 elems 0 1
		set handle_elems [hm_getmark elems 1]
		set FindHoleNode_out [FindHoleNodesAndFlangeNodes $handle_elems]
		set new_list_node_h [lindex $FindHoleNode_out 0]
		set new_list_node_f [lindex $FindHoleNode_out 1]

		## Find old elems
		set old_elems $elems_3d
		set flag 1
		while {$flag == 1} {
			hm_markclearall 1
			hm_markclearall 2 
			eval *createmark elems 1 $old_elems
			*findmark elems 1 257 1 elems 0 2
			set Founds [hm_getmark elems 2]
			if {[llength $Founds]==0} {
				set flag 0
			} else {
				set old_elems [concat $old_elems $Founds]
			}
		}
		
		## Find hole nodes of old model
		set FindHoleNode_out [FindHoleNodesAndFlangeNodes $old_elems]
		set old_list_node_h [lindex $FindHoleNode_out 0]
		set old_list_node_f [lindex $FindHoleNode_out 1]
		# Create a local system in bottom node
		hm_markclearall 1
		hm_markclearall 2
		*createmark nodes 1 $node_bot
		*systemcreate 1 0 $node_bot "z-axis" $node_top "xz plane" [lindex [lindex $new_list_node_h 0] 0]
		*createmarklast systems 1
		variable local_sys [hm_getmark systems 1]
		## Find root node 1
		set new_list_node_h [lsort -command compare4 $new_list_node_h]
		set hole_bot1 [lindex $new_list_node_h 0]
		hm_markclearall 1
		*createcenternode [lindex $hole_bot1 0] [lindex $hole_bot1 1] [lindex $hole_bot1 [expr ([llength $hole_bot1]-1)/2]]
		*createmarklast nodes 1
		set root_node1 [hm_getmark nodes 1]
		## Find root node 2
		set old_list_node_h [lsort -command compare4 $old_list_node_h]
		set hole_bot2 [lindex $old_list_node_h 0]
		hm_markclearall 1
		*createcenternode [lindex $hole_bot2 0] [lindex $hole_bot2 1] [lindex $hole_bot2 [expr ([llength $hole_bot2]-1)/2]]
		*createmarklast nodes 1
		set root_node2 [hm_getmark nodes 1]
		## Move old elements
		set root_node1_x [hm_getvalue nodes id=$root_node1 dataname=x]
		set root_node1_y [hm_getvalue nodes id=$root_node1 dataname=y]
		set root_node1_z [hm_getvalue nodes id=$root_node1 dataname=z]
		set root_node2_x [hm_getvalue nodes id=$root_node2 dataname=x]
		set root_node2_y [hm_getvalue nodes id=$root_node2 dataname=y]
		set root_node2_z [hm_getvalue nodes id=$root_node2 dataname=z]
		hm_markclearall 1
		hm_markclearall 2
		eval *createmark elems 1 $old_elems
		*createvector 1 [expr $root_node1_x-$root_node2_x] [expr $root_node1_y-$root_node2_y] [expr $root_node1_z-$root_node2_z]
		*translatemark elems 1 1 [lindex [hm_getdistance nodes $root_node1 $root_node2 0] 0]
		## Delete local system
		*createmark systems 1 $local_sys
		*deletemark systems 1
		hm_markclearall 1
		*createmark nodes 1 $root_node1 $root_node2
		*nodemarkcleartempmark 1
		## Delete 1 times attached from old_list_node_f
		set old_node_f []
		foreach list $old_list_node_f {
			set old_node_f [concat $old_node_f $list]
		}
		hm_markclearall 1
		hm_markclearall 2
		eval *createmark nodes 1 $old_node_f
		*findmark nodes 1 257 1 elems 0 2
		set del_elems_1 [hm_getmark elems 2]
		hm_markclearall 1
		hm_markclearall 2
		eval *createmark elems 1 $del_elems_1
		*deletemark elems 1
		# Delete 1 times attached from group beam
		if {[llength $$del_elems] != 0} {
			hm_markclearall 1
			hm_markclearall 2
			eval *createmark elems 1 $del_elems
			*deletemark elems 1	
		}

		# Match each couple hole
		set new_list_node_h_1 $new_list_node_h
		foreach hole_old $old_list_node_h {
			if {[llength $new_list_node_h_1]==0} {
				continue
			}
			variable hole0 $hole_old
			set new_list_node_h_1 [lsort -command compare1 $new_list_node_h_1]
			set hole_new [lindex $new_list_node_h_1 0]
			set new_list_node_h_1 [lreplace $new_list_node_h_1 0 0]

			##Find comp id of hole new
			hm_markclearall 1
			hm_markclearall 2
			eval *createmark nodes 1 $hole_new
			*findmark nodes 1 257 1 elems 0 2
			set New_comp_id [hm_getvalue elems id=[lindex [hm_getmark elems 2] 0] dataname=collector]
			set New_comp_name [hm_getvalue comps id=$New_comp_id dataname=name]
			
			# Find flange nodes of old hole
			hm_markclearall 1
			hm_markclearall 2
			eval *createmark nodes 1 $hole_old
			*findmark nodes 1 257 1 elems 0 2
			set Founds [hm_getmark elems 2]
			set flange_elems []
			foreach elem $Founds {
				set elem_typename [hm_getvalue elems id=$elem dataname=typename]
				if {$elem_typename == "CTRIA3" || $elem_typename == "CQUAD4"} {
					set flag 1
					lappend flange_elems $elem
				}
			}
			set flag 1
			set i 0
			hm_markclearall 1
			hm_markclearall 2
			eval *createmark elems 2 $Founds
			while {$flag == 1 && $i < 10} {
				*findmark elems 2 257 1 elems 0 1
				set Founds [hm_getmark elems 1]
				set flag 0
				foreach elem $Founds {
					set elem_typename [hm_getvalue elems id=$elem dataname=typename]
					if {$elem_typename == "CTRIA3" || $elem_typename == "CQUAD4"} {
						set flag 1
						lappend flange_elems $elem
					}
				}
				hm_markclearall 1
				hm_markclearall 2 
				eval *createmark elems 2 $flange_elems
				incr i
			}
			set FindHoleNode_out [FindHoleNodesAndFlangeNodes $flange_elems]
			set flange_old [lindex [lindex $FindHoleNode_out 1] 0]
			
			## Confirm and handle arc flange
			hm_markclearall 1
			hm_markclearall 2
			eval *createmark nodes 1 $flange_old
			*findmark nodes 1 257 1 elems 0 2
			set temp_elems [hm_getmark elems 2]
			foreach elem $temp_elems {
				set elem_typename [hm_getvalue elems id=$elem dataname=typename]
				if {$elem_typename == "CTRIA3" || $elem_typename == "CQUAD4"} {
					set flange_elem $elem
					break
				}
			}
			set flange_comp [hm_getvalue elems id=$flange_elem dataname=collector]
			set flange_elems [hm_getvalue comps id=$flange_comp dataname=elements]
			set fhnafnad_out [FindHoleNodesAndFlangeNodesOfADomain $flange_elems]
			set hole_old [lindex $fhnafnad_out 0]
			set flange_old [lindex $fhnafnad_out 1]
			set check3d [CheckIsConnectWith3d $flange_elems]
			
			if {$check3d==0} {
				set flange_elems [hm_getvalue comps id=$flange_comp dataname=elements]
				set fhnafnad_out [FindHoleNodesAndFlangeNodesOfADomain $flange_elems]
				set hole_old [lindex $fhnafnad_out 0]
				set flange_old $hole_old
			}

			## Find the most fit new hole
			set FindFitNewHole_out [FindFitNewHole $hole_new $flange_old]
			set hole_new [lindex $FindFitNewHole_out 0]
			set del_elems_2 [lindex $FindFitNewHole_out 1]
			
			## Assembly
			set remesh_comp [AssemblyByRuled $hole_new $flange_old $del_elems_2]

			## Find remesh elems
			hm_markclearall 1
			hm_markclearall 2
			*createmark elems 1 "by comp" $remesh_comp
			set Remesh_elems [hm_getmark elems 1]

			## Move remesh element to new component and delete temp comp
			set del_comp [hm_getvalue elems id=[lindex $Remesh_elems 0] dataname=collector]
			if {$del_comp!=$New_comp_id} {
				hm_markclearall 1
				eval *createmark elems 1 $Remesh_elems
				*movemark elements 1 $New_comp_name
				hm_markclearall 1
				*createmark comps 1 $del_comp
				*deletemark comps 1
			}
			
			## Check and reverse normal of remesh elements
			CheckNormalAndReserve $Remesh_elems $New_comp_id
			
			if {$check3d==0} {
				## Delete old flange if it's of arc
				*createmark comps 1 $flange_comp
				*deletemark comps 1
			} else {
				# Move old elem to new component
				if {$flange_comp!=$New_comp_id} {
					hm_markclearall 1
					eval *createmark elems 1 $flange_elems
					*movemark elements 1 $New_comp_name
					
					## Check and reverse normal of flange old elements
					CheckNormalAndReserve $flange_elems $New_comp_id
				}
			}

			## Remesh10
			Remesh10 $Remesh_elems
		}
		
		# Move old elements into new assembly
		hm_markclearall 1
		hm_markclearall 2
		eval *createmark elems 2 $old_elems
		*createstringarray 2 "elements_on" "geometry_on"
		*isolateentitybymark 2 1 2
		hm_markclearall 1
		hm_markclearall 2
		*createmark comps 2 "displayed"
		set old_comps [hm_getmark comps 2]
		
		foreach assem $b_assems {
			set assem_comps [hm_getvalue assemblies id=$assem dataname=components]
			set assem_comps [concat $assem_comps $old_comps]
			
			*setvalue assems id=$assem components={components $assem_comps}
		}
		
		
	} 
	puts "Beam - solid DONE"
}

proc CheckNormalAndReserve {Check_elems Base_comp_id} {
	set nor_x [hm_getvalue elems id=[lindex $Check_elems 0] dataname=normalx]
	set nor_y [hm_getvalue elems id=[lindex $Check_elems 1] dataname=normaly]
	set nor_z [hm_getvalue elems id=[lindex $Check_elems 2] dataname=normalz]
	set Check_elems_normal [list $nor_x $nor_y $nor_z]

	eval *createmark elems 1 $Check_elems
	*findmark elems 1 257 1 elems 0 2
	set Founds [hm_getmark elems 2]
	
	foreach ele $Founds {
		set comp_id [hm_getvalue elems id=$ele dataname=collector]
		if {$comp_id==$Base_comp_id} {
			set nor_x [hm_getvalue elems id=$ele dataname=normalx]
			set nor_y [hm_getvalue elems id=$ele dataname=normaly]
			set nor_z [hm_getvalue elems id=$ele dataname=normalz]
			set Base_comp_normal [list $nor_x $nor_y $nor_z]
			break
		}	
	}
	if {[llength $Check_elems_normal]!=0 && [llength $Base_comp_normal]!=0} {
		set mdv [MulNoneDirOfTwoVector $Check_elems_normal $Base_comp_normal]
		if {$mdv<0} {
			eval *createmark elems 1 $Check_elems
			*normalsreverse elems 1 10
			*normalsoff
		}
	}
}


proc AssemblyByRuled {hole_new flange_old del_elems} {

	## create new comp for remesh elements
	hm_markclearall 1
	hm_markclearall 2
	*createentity comp
	*createmarklast comps 1
	set remesh_comp [hm_getmark comps 1]
	set remesh_comp_name [hm_getvalue comps id=$remesh_comp dataname=name]
	
	## Create edges for keep nodes of flange_old
	hm_markclear all 1
	eval *createmark elems 1 $del_elems
	*findedges1 elems 1 0 0 0 30
	*createmarklast elems 1
	set edges [hm_getmark elems 1]
	
	## Delete not need anymore elements
	hm_markclearall 1
	hm_markclearall 2
	eval *createmark elems 1 $del_elems
	*deletemark elems 1
	
	## Arrange 2 list nodes
	set flange_old [FisrtNodesOfFlange $hole_new $flange_old]
	set hole_new [SortPathNodesFolowFlow $hole_new $flange_old]

	# Assembly new hole to old flange
	hm_markclearall 1
	hm_markclearall 2
	*surfacemode 2
	eval *createlist nodes 1 $flange_old
	eval *createlist nodes 2 $hole_new
	*linearsurfacebetweennodes 1 2 0
	*set_meshfaceparams 0 1 2 3 0 1 0.5 1 1
	*set_meshedgeparams 0 19 0 0 0 0 0 0 0
	*set_meshedgeparams 1 1 0 0 0 0 0 0 0
	*set_meshedgeparams 2 15 0 0 0 0 0 0 0
	*set_meshedgeparams 3 1 0 0 0 0 0 0 0
	*automesh 0 1 2
	*storemeshtodatabase 0
	*createmarklast elems 1
	set ruled_elems [hm_getmark elems 1]
	
	# Assembly the last elements new hole to old flange
	hm_markclearall 1
	hm_markclearall 2
	*surfacemode 2
	*createlist nodes 1 [lindex $flange_old end] [lindex $flange_old 0]
	*createlist nodes 2 [lindex $hole_new end] [lindex $hole_new 0]
	*linearsurfacebetweennodes 1 2 0
	*set_meshfaceparams 0 1 2 3 0 1 0.5 1 1
	*set_meshedgeparams 0 19 0 0 0 0 0 0 0
	*set_meshedgeparams 1 1 0 0 0 0 0 0 0
	*set_meshedgeparams 2 15 0 0 0 0 0 0 0
	*set_meshedgeparams 3 1 0 0 0 0 0 0 0
	*automesh 0 1 2
	*storemeshtodatabase 0
	*createmarklast elems 1
	set ruled_elems [concat $ruled_elems [hm_getmark elems 1]]
	
	## Move ruled elements to remesh component
	hm_markclearall 2
	eval *createmark elems 2 $ruled_elems
	*movemark elements 2 $remesh_comp_name
	
	## Delete not need anymore edges
	hm_markclearall 1
	hm_markclearall 2
	eval *createmark elems 1 $edges
	*deletemark elems 1
	
	return $remesh_comp
}



proc FisrtNodesOfFlange {hole flange} {
	set list1 []
	foreach node1 $flange {
		set list2 []
		foreach node2 $hole {
			set dist [lindex [hm_getdistance nodes $node1 $node2 0] 0]
			lappend list2 $dist
		
		}
		set list2 [lsort -real $list2]
		lappend list1 $list2
	}
	set list1_new [lsort -command compare5 $list1]
	set idx [lsearch -exact $list1 [lindex $list1_new 0]]
	set list2 [concat [lrange $flange $idx end] [lrange $flange 0 [expr $idx-1]]]
	set flange $list2
	
	return $flange
}



proc CheckIsConnectWith3d {check_elems} {
	hm_markclearall 1
	hm_markclearall 2
	eval *createmark elems 1 $check_elems
	*findmark elems 1 257 1 elems 0 2
	set Founds [hm_getmark elems 2]
	set elems_3d []
	foreach elem $Founds {
		set elem_typename [hm_getvalue elems id=$elem dataname=typename]
		if {$elem_typename == "CTETRA"} {
			lappend elems_3d $elem
		}
	}
	if {[llength $elems_3d]!=0} {
		return 1
	} else {
		return 0
	}
}


proc Remesh10 {Remesh_elems} {
	if {[llength $Remesh_elems]==0} {
		puts "Remesh10: List elems is none"
		return 0
	}
	hm_markclearall 1
	hm_markclearall 2
	eval *createmark elems 1 $Remesh_elems
	##Criteria setting
	*createstringarray 16 " 0 penalty value              0.00    0.00    0.80    1.00   10.00" \
	  "  1 min length        1 1.0  10.000   8.880   3.240   1.010   0.000    1   59    0" \
	  "  2 max length        1 1.0  10.000  11.200  13.010  15.990  21.980    1   39    1" \
	  "  3 aspect ratio      0 1.0   1.000   2.000   4.390   4.990   9.980    0   41    2" \
	  "  4 warpage           1 1.0   0.000  10.000  26.000  29.990  59.980    5   56    3" \
	  "  5 max angle quad    1 1.0  90.000 122.000 160.400 169.990 202.000    0   28    4" \
	  "  6 min angle quad    1 1.0  90.000  58.000  19.610  10.010   0.000    0   61    5" \
	  "  7 max angle tria    1 1.0  60.000  94.990 151.000 164.990 217.500    0   19    6" \
	  "  8 min angle tria    1 1.0  60.000  41.670  12.350   5.010   0.000    0   22    7" \
	  "  9 skew              0 1.0   0.000  10.000  34.000  40.000  70.000    5   46    8" \
	  " 10 jacobian          0 1.0   1.000   0.900   0.700   0.600   0.300    0   57    9" \
	  " 11 chordal dev       0 1.0   0.000   0.300   0.800   1.000   2.000    0   29   10" \
	  " 12 taper             0 1.0   0.000   0.200   0.500   0.600   0.900    0   53   11" \
	  " 13 % of trias        0 1.0   0.000   6.000  10.000  15.000  20.000    0    0   -1" \
	  " 14 QI color legend            32      32       7       6       3           3   12" \
	  " 15 time_step         0      10.000                   0.010            0   59   12"
	*setqualitycriteria 1 16 1
	##Remesh
	*optimized_elements_remesh2 1 "dummy" 10 2 30 30 1 0 3
}


proc GetNormalVector {nodes} {

	set node1 [lindex $nodes 0]
	set x1 [hm_getvalue node id=$node1 dataname=x]
	set y1 [hm_getvalue node id=$node1 dataname=y]
	set z1 [hm_getvalue node id=$node1 dataname=z]

	set node2 [lindex $nodes 1]
	set x2 [hm_getvalue node id=$node2 dataname=x]
	set y2 [hm_getvalue node id=$node2 dataname=y]
	set z2 [hm_getvalue node id=$node2 dataname=z]

	set node3 [lindex $nodes 2]
	set x3 [hm_getvalue node id=$node3 dataname=x]
	set y3 [hm_getvalue node id=$node3 dataname=y]
	set z3 [hm_getvalue node id=$node3 dataname=z]

	set dx [expr ($y2 - $y1)*($z3-$z1) - ($z2-$z1)*($y3-$y1)]
	set dy [expr ($z2 - $z1)*($x3-$x1) - ($x2-$x1)*($z3-$z1)]
	set dz [expr ($x2 - $x1)*($y3-$y1) - ($y2-$y1)*($x3-$x1)]

	set vector [list $dx $dy $dz]
	return $vector
}


proc FindFitNewHole {hole_new flange_old} {
	if {[llength $hole_new]==0 || [llength $flange_old]==0} {
		puts "FindFitNewHole: List nodes is none"
		return 0
	}
	# Find radius of flange
	hm_markclearall 1
	*createcenternode [lindex $hole_new 0] [lindex $hole_new 1] [lindex $hole_new [expr ([llength $hole_new]-1)/2]]
	*createmarklast nodes 1
	set flange_cnode [hm_getmark nodes 1]
	
	variable node0 $flange_cnode
	set compare_list1 [lsort -command compare $flange_old]
	set flange_rnode [lindex $compare_list1 0]
	set flange_r [lindex [hm_getdistance nodes $flange_cnode $flange_rnode 0] 0]
	set times_max 5
	set times 0
	set flag 0
	set temp_elems []

	while {$flag == 0 && $times<$times_max} {
		## Find radius of new hole and radius of one layer mesh from this
		set compare_list2 [lsort -command compare $hole_new]
		set hole1_rnode [lindex $compare_list2 0]
		set hole1_r [lindex [hm_getdistance nodes $flange_cnode $hole1_rnode 0] 0]

		hm_markclearall 1
		hm_markclearall 2
		eval *createmark nodes 1 $hole_new
		*findmark nodes 1 257 1 elems 0 2
		set temp_elems [concat $temp_elems [hm_getmark elems 2]]
		
		set FindHoleNode_out [FindHoleNodesAndFlangeNodes $temp_elems]
		set flange_new [lindex [lindex $FindHoleNode_out 1] 0]
		if {[llength $flange_new]==0} {
			puts "FindFitNewHole: not found new flange"
			break
		}
		variable node0 $flange_cnode
		set compare_list3 [lsort -command compare $flange_new]
		set hole2_rnode [lindex $compare_list3 0]
		set hole2_r [lindex [hm_getdistance nodes $flange_cnode $hole2_rnode 0] 0]
		## Find nearest hole radius to old flange radius
		if {[expr abs($flange_r - $hole2_r)]<[expr abs($flange_r - $hole1_r)]} {
			set hole_new $flange_new
			set flag 0
		} else {
			set flag 1
		}
		incr times
	}
	
	## Find nodes too close old flange
	set flag1 0
	set times 0
	while {$flag1==0 && $times < 4} {
		set NG_nodes []
		foreach node $hole_new {
			variable node0 $node
			set flange_old_1 [lsort -command compare $flange_old]
			set dist [lindex [hm_getdistance nodes $node [lindex $flange_old_1 end] 0] 0]
			if {$dist<3} {
				lappend NG_nodes $node
			}
		}
		if {[llength $NG_nodes]>0} {
			## Find NG elements from NG nodes
			hm_markclearall 1
			hm_markclearall 2
			eval *createmark nodes 1 $NG_nodes
			*findmark nodes 1 257 1 elems 0 2
			set NG_elems [hm_getmark elems 2]
			## Delete NG elem
			set temp_elems [concat $temp_elems $NG_elems]
			
			## Refind hole new
			set FindHoleNode_out [FindHoleNodesAndFlangeNodes $temp_elems]
			set hole_new [lindex [lindex $FindHoleNode_out 1] 0]
		} else {
			set flag1 1
		}
		
		incr times
	}

	# Delete flange center node
	hm_markclearall 1
	*createmark nodes 1 $flange_cnode
	*nodemarkcleartempmark 1

	return [list $hole_new $temp_elems]
}


proc MatchCountNodes {hole_new flange_old} {
	if {[llength $hole_new]==0 || [llength $flange_old]==0} {
		puts "MatchCountNodes: 2 list are same node count"
		return $hole_new
	}
	set hole_new2 []
	
	## create new comp and add offset_elems to
	hm_markclearall 1
	hm_markclearall 2
	*createentity comp
	*createmarklast comps 1
	set offset_comp [hm_getmark comps 1]
	set offset_comp_name [hm_getvalue comps id=$offset_comp dataname=name]
	
	## Add more nodes for hole new
	if {[llength $hole_new] < [llength $flange_old]} {
		hm_markclearall 1
		hm_markclearall 2
		eval *createmark nodes 1 $hole_new
		*findmark nodes 1 257 1 elems 0 2
		set elem_layer1 [hm_getmark elems 2]
		hm_markclearall 1
		hm_markclearall 2
		eval *createmark elems 1 $elem_layer1
		*findmark elems 1 257 1 nodes 0 2
		set node_layer1 [hm_getmark nodes 2]
		set hole_base []
		foreach node $node_layer1 {
			if {$node ni $hole_new} {
				lappend hole_base $node
			}
		}
		## Offset base elems 0.0001 mm
		set list_nodes1 [list [lindex $hole_new 0] [lindex $hole_new 1] [lindex $hole_new [expr ([llength $hole_new]-1)/2]]]
		set nor_vector [GetNormalVector $list_nodes1]
		hm_markclearall 1
		eval *createmark elems 1 $elem_layer1
		*duplicatemark elems 1 1
		*createvector 1 [lindex $nor_vector 0] [lindex $nor_vector 1] [lindex $nor_vector 2]
		*translatemark elems 1 1 0.0001
		*createmarklast elems 1
		set offset_elems [hm_getmark elems 1]
		## Move offset_elems to offset_comp
		hm_markclearall 2
		eval *createmark elems 2 $offset_elems
		*movemark elements 2 $offset_comp_name
		set FindHoleNode_out [FindHoleNodesAndFlangeNodes $offset_elems]
		set hole_new1 [lindex [lindex $FindHoleNode_out 0] 0]
		set flange_new1 [lindex [lindex $FindHoleNode_out 1] 0]
		
		## Split for add more nodes
		set times_max [expr [llength $flange_old] - [llength $hole_new1]]
		set times 0
		set hole_new2 $hole_new1
		while {[llength $hole_new2] < [llength $flange_old] && $times < $times_max} {
			## Find split nodes = longest edge
			set edges [FindLongestEdge $hole_new2]
			set split_nodes []
			
			foreach edge $edges {
				set split_nodes [concat $split_nodes $edge]
				incr times
				if {$times >= $times_max} {
					break
				}
			}

			hm_markclearall 1
			hm_markclearall 2
			*createmark elems 2
			eval *createarray [llength $split_nodes] $split_nodes
			*split_hex_continuum 1 [llength $split_nodes] elems 2 1 1 0 1
			## Refind hole nodes
			hm_markclearall 1
			hm_markclearall 2
			*createmark elems 1 "by comp" $offset_comp
			set FindHoleNode_out [FindHoleNodesAndFlangeNodes [hm_getmark elems 1]]
			set hole_new2 [lindex [lindex $FindHoleNode_out 0] 0]
			set flange_new2 [lindex [lindex $FindHoleNode_out 1] 0]
		}
		#Reset hole_new nodes
		set hole_new $hole_new2
		
		## Join redundant nodes in flange_new2
		foreach node $flange_new2 {
			if {$node ni $flange_new1} {
				variable node0 $node
				set list1 [lsort -command compare $flange_new1]
				set closest_nodes [lindex $list1 end]
				hm_answernext yes
				*replacenodes $node $closest_nodes 1 0
			}
		}
		
		# ## Assembly flange_new1 to hole_base
		hm_markclearall 1
		eval *createmark nodes 1 $hole_base
		set hole_base [hm_getmark nodes 1]
		for {set i 0} {$i < [llength $flange_new1]} {incr i} {
			variable node0 [lindex $flange_new1 $i]
			set hole_base [lsort -command compare $hole_base]
			set closest_nodes [lindex $hole_base end]
			hm_answernext yes
			*replacenodes [lindex $flange_new1 $i] $closest_nodes 1 0
		}
		
		## Delete old layer mesh of base hole
		hm_markclearall 1
		eval *createmark elems 1 $elem_layer1
		*deletemark elems 1	
		
	} elseif {[llength $hole_new] > [llength $flange_old]} {
		## Cutout nodes from hole new
		set times_max [expr [llength $hole_new] - [llength $flange_old]]
		hm_markclearall 1
		hm_markclearall 2
		eval *createmark nodes 1 $hole_new
		*findmark nodes 1 257 1 elems 0 2
		set elem_layer1 [hm_getmark elems 2]
		set FindHoleNode_out [FindHoleNodesAndFlangeNodes $elem_layer1]
		set hole_new [lindex [lindex $FindHoleNode_out 0] 0]
		for {set i 0} {$i < [llength $hole_new]} {incr i} {
			hm_answernext yes
			*replacenodes [lindex $hole_new $i] [lindex $hole_new [expr $i+1]] 1 0
			if {$i>=[expr $times_max-1]} {
				break
			}
		}
		## Remark hole new node after cutout nodes
		hm_markclearall 1
		hm_markclearall 2
		eval *createmark nodes 1 $hole_new
		set hole_new [hm_getmark nodes 1]
		## Move offset_elems to offset_comp
		eval *createmark nodes 1 $hole_new
		*findmark nodes 1 257 1 elems 0 2
		set Remesh_elems [hm_getmark elems 2]
		hm_markclearall 2
		eval *createmark elems 2 $Remesh_elems
		*movemark elements 2 $offset_comp_name
		
		set FindHoleNode_out [FindHoleNodesAndFlangeNodes $Remesh_elems]
		set hole_new [lindex [lindex $FindHoleNode_out 0] 0]
	} else {
		eval *createmark nodes 1 $hole_new
		*findmark nodes 1 257 1 elems 0 2
		set Remesh_elems [hm_getmark elems 2]
		hm_markclearall 2
		eval *createmark elems 2 $Remesh_elems
		*movemark elements 2 $offset_comp_name
	}

	return [list $hole_new $offset_comp]
	
}

proc FindLongestEdge {hole_new} {
	set list1 []
	for {set i 0} {$i<[llength $hole_new]} {incr i} {
		set edge [list [lindex $hole_new $i] [lindex $hole_new [expr $i+1]]]
		if {$i==[expr [llength $hole_new]-1]} {
			set edge [list [lindex $hole_new $i] [lindex $hole_new 0]]
		}
		lappend list1 $edge
	}
	set list1 [lsort -command compare6 $list1]
	return $list1
}


proc compare6 {a b} {
	set dist1 [lindex [hm_getdistance nodes [lindex $a 0] [lindex $a 1] 0] 0]
	set dist2 [lindex [hm_getdistance nodes [lindex $b 0] [lindex $b 1] 0] 0]
	if {[expr abs($dist1)] > [expr abs($dist2)]} {
		return -1
	} else {
		return 1
	}
}


## For path almost circle shape
proc SortNodesToPath {base} {
	set list1 $base
	set list2 [list [lindex $list1 0]]
	set list1 [lreplace $list1 0 0]
	variable item
	set len [llength $list1]
	for {set i 0} {$i<$len} {incr i} {
		set item [lindex $list2 end]
		set list1 [lsort -command compare2 $list1]
		lappend list2 [lindex $list1 0]
		set list1 [lreplace $list1 0 0]
	}
	set base $list2
	return $base
}


proc SortPathNodesFolowFlow {base flow} {
	
	# Fit the first node
	set list1 $base
	variable item [lindex $flow 0]
	set list1 [lsort -command compare2 $list1]
	set list2_node0 [lindex $list1 0]
	set idx [lsearch $base $list2_node0]
	set list2 [concat [lrange $base $idx end] [lrange $base 0 [expr $idx-1]]]
	set base $list2
	
	# Reverse base if counter direction with flow
	set x1 [hm_getvalue nodes id=[lindex $base 0] dataname=x]
	set y1 [hm_getvalue nodes id=[lindex $base 0] dataname=y]
	set z1 [hm_getvalue nodes id=[lindex $base 0] dataname=z]
	
	set x2 [hm_getvalue nodes id=[lindex $base 1] dataname=x]
	set y2 [hm_getvalue nodes id=[lindex $base 1] dataname=y]
	set z2 [hm_getvalue nodes id=[lindex $base 1] dataname=z]
	
	set x3 [hm_getvalue nodes id=[lindex $flow 0] dataname=x]
	set y3 [hm_getvalue nodes id=[lindex $flow 0] dataname=y]
	set z3 [hm_getvalue nodes id=[lindex $flow 0] dataname=z]
	
	set x4 [hm_getvalue nodes id=[lindex $flow 1] dataname=x]
	set y4 [hm_getvalue nodes id=[lindex $flow 1] dataname=y]
	set z4 [hm_getvalue nodes id=[lindex $flow 1] dataname=z]
	
	set v1 [list [expr $x2 - $x1] [expr $y2 - $y1] [expr $z2 - $z1]]
	set v2 [list [expr $x4 - $x3] [expr $y4 - $y3] [expr $z4 - $z3]]
	
	set mnd [MulNoneDirOfTwoVector $v1 $v2]
	if {$mnd<0} {
		set hole_new_node1 [lindex $base 0]
		set base [lreplace $base 0 0]
		set base [lreverse $base]
		set base [linsert $base 0 $hole_new_node1]
	}
	return $base
}

proc MulNoneDirOfTwoVector {v1 v2} {
	set v1_x [lindex $v1 0]
	set v1_y [lindex $v1 1]
	set v1_z [lindex $v1 2]
	
	set v2_x [lindex $v2 0]
	set v2_y [lindex $v2 1]
	set v2_z [lindex $v2 2]
	
	set mnd [expr ($v1_x*$v2_x)+($v1_y*$v2_y)+($v1_z*$v2_z)]
	return $mnd
}


proc FindHoleNodesAndFlangeNodesOfADomain {list_elems} {
	hm_markclearall 1
	hm_markclearall 2
	eval *createmark elems 1 $list_elems
	set list_bnodes0 [hm_getedgeloops elems markid=1 looptype=2 restricttoinput=1]
	set list_bnodes []
	foreach list $list_bnodes0 {
		set new_list [lrange $list 2 end]
		lappend list_bnodes $new_list
	}
	
	set a_r [FindHoleRadius [lindex $list_bnodes 0]]
	set b_r [FindHoleRadius [lindex $list_bnodes end]]
	if {$a_r > $b_r} {
		set hole [lindex $list_bnodes end]
		set flange [lindex $list_bnodes 0]
	} else {
		set flange [lindex $list_bnodes end]
		set hole [lindex $list_bnodes 0]
	}

	
	return [list $hole $flange]

}

proc FindHoleRadius {hole_base} {
	hm_markclearall 1
	*createcenternode [lindex $hole_base 0] [lindex $hole_base 1] [lindex $hole_base [expr ([llength $hole_base]-1)/2]]
	*createmarklast nodes 1
	set base_cnode [hm_getmark nodes 1]
	variable node0 $base_cnode
	set hole_base [lsort -command compare $hole_base]
	set r_nodes [lindex $hole_base 0]
	set hole_r [lindex [hm_getdistance nodes $r_nodes $base_cnode 0] 0]
	
	## Delete center node
	hm_markclearall 1
	*createmark nodes 1 $base_cnode
	*nodemarkcleartempmark 1
	
	return $hole_r
}

proc FindHoleNodesAndFlangeNodes {list_elems} {
	hm_markclearall 1
	hm_markclearall 2
	eval *createmark elems 1 $list_elems
	set list_bnodes0 [hm_getedgeloops elems markid=1 looptype=2 restricttoinput=1]
	set list_bnodes []
	foreach list $list_bnodes0 {
		set new_list [lrange $list 2 end]
		lappend list_bnodes $new_list
	}
	set list_nodes_h []
	set list_nodes_b []
	foreach list $list_bnodes {
		hm_markclearall 1
		hm_markclearall 2
		eval *createmark nodes 1 $list
		*findmark nodes 1 257 1 elems 0 2
		set Founds [hm_getmark elems 2]
		hm_markclearall 1
		hm_markclearall 2
		eval *createmark elems 1 $Founds
		hm_holedetectioninit
		hm_holedetectionsetentities elems 1
		hm_holedetectionfindholes 1
		set n [hm_holedetectiongetnumberofholes]
		if { $n > 0 } {
			for {set i 0} {$i < $n} {incr i} {
				set hole_inf [hm_holedetectiongetholedetails $i]
				foreach inf $hole_inf {
					if {[lindex $inf 0]=="nodes"} {
						set hole_nodes $inf
					}
				}
				set hole_nodes [lreplace $hole_nodes 0 0]
				if {[lsearch -all $hole_nodes [lindex $list 1]]!=""} {
					lappend list_nodes_h $hole_nodes
				} else {
					lappend list_nodes_b $list
				}
			}
		} else {
			lappend list_nodes_b $list
		}
		
		hm_holedetectionend
	}
	return [list $list_nodes_h $list_nodes_b]
}

proc compare {a b} {
	variable node0
	set a_d [lindex [hm_getdistance nodes $a $node0 0] 0]
	set b_d [lindex [hm_getdistance nodes $b $node0 0] 0]
	if {[expr abs($a_d)] > [expr abs($b_d)]} {
		return -1
	} else {
		return 1
	}
}

proc compare1 {a b} {
	variable hole0
	## create hole center nodes
	hm_markclearall 1
	*createcenternode [lindex $hole0 0] [lindex $hole0 1] [lindex $hole0 [expr ([llength $hole0]-1)/2]]
	*createmarklast nodes 1
	set cen_node0 [hm_getmark nodes 1]
	hm_markclearall 1
	*createcenternode [lindex $a 0] [lindex $a 1] [lindex $a [expr ([llength $a]-1)/2]]
	*createmarklast nodes 1
	set cen_node1 [hm_getmark nodes 1]
	hm_markclearall 1
	*createcenternode [lindex $b 0] [lindex $b 1] [lindex $b [expr ([llength $b]-1)/2]]
	*createmarklast nodes 1
	set cen_node2 [hm_getmark nodes 1]
	set a_d [lindex [hm_getdistance nodes $cen_node0 $cen_node1 0] 0]
	set b_d [lindex [hm_getdistance nodes $cen_node0 $cen_node2 0] 0]
	##clear temp nodes
	hm_markclearall 1
	*createmark nodes 1 $cen_node0 $cen_node1 $cen_node2
	*nodemarkcleartempmark 1
	if {[expr abs($a_d)] < [expr abs($b_d)]} {
		return -1
	} else {
		return 1
	}
	
}


proc compare2 {a b} {
	variable item
	set dist1 [lindex [hm_getdistance nodes $a $item 0] 0]
	set dist2 [lindex [hm_getdistance nodes $b $item 0] 0]
	if {[expr abs($dist1)] < [expr abs($dist2)]} {
		return -1
	} else {
		return 1
	}
}

proc compare3 {a b} {
	if {[expr abs($a)] < [expr abs($b)]} {
		return -1
	} else {
		return 1
	}
}

proc compare4 {a b} {
	variable local_sys
	variable node_bot
	hm_markclearall 1
	*createcenternode [lindex $a 0] [lindex $a 1] [lindex $a [expr ([llength $a]-1)/2]]
	*createmarklast nodes 1
	set hole_old_cnode1 [hm_getmark nodes 1]
	hm_markclearall 1
	*createcenternode [lindex $b 0] [lindex $b 1] [lindex $b [expr ([llength $b]-1)/2]]
	*createmarklast nodes 1
	set hole_old_cnode2 [hm_getmark nodes 1]
	set dist1 [lindex [hm_getdistance nodes $hole_old_cnode1 $node_bot $local_sys] 3]
	set dist2 [lindex [hm_getdistance nodes $hole_old_cnode2 $node_bot $local_sys] 3]
	*createmark nodes 1 $hole_old_cnode1 $hole_old_cnode2
	*nodemarkcleartempmark 1
	if {$dist1>$dist2} {
		return -1
	} else {
		return 1
	}
}

proc compare5 {a b} {
	set dist1 [lindex [lindex $a 0] 0]
	set dist2 [lindex [lindex $b 0] 0]
	if {$dist1 < $dist2} {
		return -1
	} else {
		return 1
	}
}


# #--------------------------------------------------------------------Import model----------------------------------------------------------------------------
proc ImportModel {model_path} {
	if {[string match "*.hm" $model_path]==1} {*readfile $model_path}
	if  {[string match "*.nas" $model_path]==1
	||[string match "*.bdf" $model_path]==1
	||[string match "*.blk" $model_path]==1
	||[string match "*.bulk" $model_path]==1
	||[string match "*.dat" $model_path]==1
	||[string match "*.nastran" $model_path]==1} {
		*feinputomitincludefiles
		*createstringarray 9 "Nastran " "NastranMSC " "ANSA " "PATRAN " "SPC1_To_SPC " \
		 "HM_READ_PCL_GRUPEE_COMMENTS " "EXPAND_IDS_FOR_FORMULA_SETS " "ASSIGNPROP_BYHMCOMMENTS" \
		 "IDRULES_SKIP"
		*feinputwithdata2 "\#nastran\\nastran" "$model_path" 0 0 0 0 0 1 9 1 0
	}
}


# #### ------ END tool SOLID SHASHI ----------------

# #### ------ start tool BEAM SHASHI ----------------



proc beam_shashi {} {
	
	*createmark elems 1 "displayed"
	set ele_colector [hm_getmark elems 1]
	# puts "ele_colector $ele_colector"
	*clearmark elems 1
	set beam_shashi [find_beam_model $ele_colector]
	set node_shashi [find_node_beam $beam_shashi]
	# puts "node_shashi $node_shashi"
	set beam_shashi_all []
	foreach a $beam_shashi {
		foreach b $a {
			lappend beam_shashi_all $b
		}
	}

	position_shashi $node_shashi $ele_colector
	set coupe_beam_model_shashi [dele_beam_NG $node_shashi $beam_shashi_all]
	set_assy_beam $coupe_beam_model_shashi
	*createmark nodes 1 "all"
	*nodemarkaddtempmark 1
	*nodecleartempmark 
	set a [SingleAndCoupe_gotai $coupe_beam_model_shashi]
	set coupe_gotail [lindex $a 0]
	set single_gotail [lindex $a 1]
	
	foreach single $single_gotail {
		replace_node_gotail_single $single
	}
	check_sampe_gotail $coupe_gotail
	foreach coup_beam $coupe_beam_model_shashi {
	 	set node_beam_model_delete [lindex $coup_beam 0]
		eval *createmark nodes 1 $node_beam_model_delete
		*findmark nodes 1 257 1 elements 0 2
		set ele_hole [hm_getmark elements 2]
		eval *createmark elements 1 $ele_hole
		*deletemark elements 1
	}	
}

	
# ##### Ngay 20-01-2025 dua gotail ve dung assy cua no
proc set_assy_beam {coupe_beam_model_shashi} {
	foreach coupe $coupe_beam_model_shashi {
		set node_shashi [lindex $coupe 1]
		set node_base [lindex $coupe 0]
		eval *createmark nodes 1 $node_shashi
		*findmark nodes 1 257 1 elements 0 2
		set elems_shashi [hm_getmark elem 2]
		set comp_shashi []
		foreach ele $elems_shashi {
			set comp_id_shashi [hm_getvalue elems id=$ele dataname=collector]
			lappend comp_shashi $comp_id_shashi
		}
		set comp_shashi [lsort -unique $comp_shashi]
		
		eval *createmark nodes 1 $node_base
		
		*findmark nodes 1 257 1 elements 0 2
		set elems [hm_getmark elem 2]
		set ele_check_comp [lindex $elems 0]
		set comp_id [hm_getvalue elems id=$ele_check_comp dataname=collector]
		*createmark assemblies 1 "all"
		set assems [hm_getmark assemblies 1]
		foreach assem $assems {
			set assem_comp [hm_getvalue assemblies id=$assem dataname=components]
			set index [lsearch $assem_comp $comp_id]
			if {$index > -1 } {
				puts $assem
				set a [llength $assem_comp]
				foreach comp_append $comp_shashi {
					lappend assem_comp $comp_append
				}
				set b [llength $assem_comp]
			}
			*setvalue assems id=$assem components={comps $assem_comp}
		}
	}
}

proc replace_node_gotail_single {single_gotail} {
	# puts "single_gotail $single_gotail "
	*createmark nodes 1 "by element id" $single_gotail
	set node_gotail_shashi [hm_getmark nodes 1]
	set node1_shashi [hm_getvalue elems id=$single_gotail dataname=node1]
	set n [lsearch $node_gotail_shashi $node1_shashi]
	set node_gotail_shashi [lreplace $node_gotail_shashi $n $n]
	
	*createmark elem 1 $single_gotail
	*findmark elements 1 257 1 elements 1 2
	set elems [hm_getmark elem 2]
	*clearmark elem 1
	
	set elem [lindex $elems 0]
	*createmark nodes 1 "by element id" $elem
	set nodes [hm_getmark nodes 1]
	set node1 [lindex $nodes 0]
	set node2 [lindex $nodes 1]
	set x1 [hm_getvalue node id=$node1 dataname=x]
	set y1 [hm_getvalue node id=$node1 dataname=y]
	set z1 [hm_getvalue node id=$node1 dataname=z]
		
	set x2 [hm_getvalue node id=$node2 dataname=x]
	set y2 [hm_getvalue node id=$node2 dataname=y]
	set z2 [hm_getvalue node id=$node2 dataname=z]
	
	set nx [expr $x1 - $x2]
	set ny [expr $y1 - $y2]
	set nz [expr $z1 - $z2]
	
	set x [hm_getvalue node id=$node1_shashi dataname=x]
	set y [hm_getvalue node id=$node1_shashi dataname=y]
	set z [hm_getvalue node id=$node1_shashi dataname=z]
	
	set nodea [lindex $node_gotail_shashi 0]
	set x_check [hm_getvalue node id=$nodea dataname=x]
	set y_check [hm_getvalue node id=$nodea dataname=y]
	set z_check [hm_getvalue node id=$nodea dataname=z]
	
	*createmark nodes 1 "by sphere" $x_check $y_check $z_check 5 inside 0 1 0
	set node_near [hm_getmark nodes 1]
	*clearmark nodes 1
	set min 100
	foreach node $node_near {
		set m [lsearch $node_gotail_shashi $node]
		if {$m == -1} {
			set dis [hm_getdistance nodes $node $nodea 0]
			set r [lindex $dis 0]
			if {$r < $min} {
				set min $r
				set nodeb $node
			}
		}
	}
	set angel [hm_getangle nodes $nodea $node1_shashi $nodeb]
	eval *createmark nodes 1 $node_gotail_shashi
	*createplane 1 $nx $ny $nz $x $y $z 
	*rotatemark nodes 1 1 $angel
	set angel_check [hm_getangle nodes $nodea $node1_shashi $nodeb]
	if {$angel_check > 1} {
		eval *createmark nodes 1 $node_gotail_shashi
		*createplane 1 $nx $ny $nz $x $y $z 
		*rotatemark nodes 1 1 [expr -1 * $angel_check]
	}
	
	foreach node1 $node_gotail_shashi {
		*createmark nodes 1 $node1 
		set node1_check [hm_getmark nodes 1]
		if {! [Null node1_check]} {
			set x0 [hm_getvalue node id=$node1 dataname=x]
			set y0 [hm_getvalue node id=$node1 dataname=y]
			set z0 [hm_getvalue node id=$node1 dataname=z]
			*createmark nodes 1 "by sphere" $x0 $y0 $z0 2 inside 0 1 0
			set node_near_check [hm_getmark nodes 1]
			set min 3
			set node_replace ""
			foreach node2 $node_near_check {
				set n [lsearch $node_gotail_shashi $node2]
				*createmark nodes 1 $node2 
				set node2_check [hm_getmark nodes 1]
				if {! [Null node2_check] && $n == -1} {
					set dis [hm_getdistance nodes $node1 $node2 0]
					set r [lindex $dis 0]
					if {$r < $min} {
						set min $r
						set node_replace $node2
					}
				}
			}
			if {$node_replace != ""} {
				*replacenodes $node_replace $node1 1 0
			}
		}
	}
}


proc check_sampe_gotail {coupe_gotail} {
	
	foreach coupe $coupe_gotail {
		set gotail_shashi [lindex $coupe 0]
		set gotail_model [lindex $coupe 1]
		*createmark nodes 1 "by element id" $gotail_shashi
		set node_gotail_shashi [hm_getmark nodes 1]
		set node1_shashi [hm_getvalue elems id=$gotail_shashi dataname=node1]
		set n [lsearch $node_gotail_shashi $node1_shashi]
		set node_gotail_shashi [lreplace $node_gotail_shashi $n $n]
		*clearmark nodes 1
		
		*createmark nodes 1 "by element id" $gotail_model
		set node_gotail_model [hm_getmark nodes 1]
		set node1_model [hm_getvalue elems id=$gotail_model dataname=node1]
		set m [lsearch $node_gotail_model $node1_model]
		set node_gotail_model [lreplace $node_gotail_model $m $m]
		*clearmark nodes 1
		
		set l1 [llength $node_gotail_shashi]
		set l2 [llength $node_gotail_model]
		set node_2_shashi [lindex $node_gotail_shashi 0]
		set dis [hm_getdistance nodes $node1_shashi $node_2_shashi 0]
		set r_new [lindex $dis 0]
		
		*createmark elements 1 $gotail_model
		*deletemark elements 1
		
		if {$l1 == $l2} {	
			foreach node_shashi $node_gotail_shashi {
				set x [hm_getvalue node id = $node_shashi dataname = x]
				set y [hm_getvalue node id = $node_shashi dataname = y]
				set z [hm_getvalue node id = $node_shashi dataname = z]
				*createmark nodes 1 "by sphere" $x $y $z 10 inside 0 1 0
				set node_near [hm_getmark nodes 1]
				set max 15
				foreach node_n $node_near {
					if {[lsearch $node_gotail_model $node_n] > -1 } {
						set dis_check [hm_getdistance nodes $node_shashi $node_n 0]
						set r [lindex $dis_check 0]
						if {$r < $max} {
							set max $r
							set node_ok $node_n
						}
					}
				}
				if {$max != 15} {
					hm_answernext yes
					*replacenodes $node_ok $node_shashi 1 0
					set m [lsearch $node_gotail_model $node_ok]
					set node_gotail_model [lreplace $node_gotail_model $m $m]
				}
			}
		} else {
			eval *createmark nodes 1 $node_gotail_model
			*findmark nodes 1 257 1 elements 0 2
			set ele_hole [hm_getmark elements 2]
			*createstringarray 109 "fileversion 20210" "geometry_cleanup_flag                1" \
			  "meshing_flag                         5" "element_size                         10" \
			  "element_type                         2" "mesh_align                           3" \
			  "element_order                        1" "surf_component                       1" \
			  "feature_angle                        25" "holes_table_begin" "appl_surf(1)" \
			  "appl_solid(1)" "appl_cordsfiles(0)" "appl_flanged_suppr(1)" "flanged_suppr_height(1.5)" \
			  "narrow_slots_type(2)" "slots_squaretip_maxwidth(  L*1.4 )" "slots_squaretip_maxchorddev(  -1 )" \
			  "appl_rmv_washer_loops(1)" "abs_fixed_nodes_count_max(0)" "solid_tube_diams_ratio_max(2.5)" \
			  "solid_tube_cross_sect_size_max(100)" "shape(1) rad(0.0,40) do action(0) modif_radius(1) target_radius($r_new) elems($l1) elems_mode(exact) washer(0) mesh_ptrn(0) " \
			  "shape(2) width(0.0,0.9595) length(0.0,14) do action(1) washer(0) mesh_ptrn(0) " \
			  "shape(2) width(0.0,0.9595) length(14,-1) do action(0) elems(auto) washer(0) mesh_ptrn(3) " \
			  "shape(2) width(0.9595,8) length(0.9595,-1) do action(0) elems(auto) washer(0) mesh_ptrn(2) " \
			  "shape(2) width(8,14) length(8,-1) do action(0) elems(6) washer(0) mesh_ptrn(2) " \
			  "shape(2) width(14,60) length(14,-1) do action(0) elems(6) washer(1) layers(auto) mesh_ptrn(0) " \
			  "shape(62) eq_diam(0.0,8) do action(1) washer(0) mesh_ptrn(0) " "rad(0.0,4) solid(1) do action(1) " \
			  "holes_table_end" "edge_fillet_recognition              1" "max_fillet_radius                    9" \
			  "surface_fillet_table_begin" "surface_fillet_recognition(1)" "minimize_transitions(1)" \
			  "rad(2.8,6.5) wid(4.31,10.2) do elems(1)" "rad(6.5,15) wid(10.2,24) do elems(2)" \
			  "surface_fillet_table_end" "del_dupl_surfs_flag                  1" "del_dupl_surfs_tol                   -1" \
			  "edges_stitch_flags                   2" "max_edges_stitch_tol                 -1.0" \
			  "fix_overlapsurfs_flag                1" "overlapsurfs_maxtangangle            -1.0" \
			  "merge_narrow_surfs                   1" "narrow_surfs_merge_width             Lmin*0.67" \
			  "narrow_surfs_sharp_edge_merge_width  Lmin*0.67" "beads_suppression                    1" \
			  "beads_recognition                    1" "minimal_beads_height                 2" \
			  "beads_treat_flags                    0" "flange_recognition                   1" \
			  "flange_elements_across               2" "flange_max_width                     35" \
			  "flange_min_width                     5" "flanges_treat_flags                  1" \
			  "flange_max_remove_width              -1.0" "appl_tria_reduction                  1" \
			  "common_mesh_flow                     1" "extract_thinsolids                   0" \
			  "midsurf_method                       3" "thinsolid_ratio                      0.3" \
			  "max_thickness                        15" "extract_feature_angle                25" \
			  "pre_midsurf_cleanup                  0" "direct_midmesh                       0" \
			  "ignore_flat_edges                    1" "flatten_connections                  0" \
			  "step_offset_mode                     0" "defeat_open_width_on                 0" \
			  "defeat_open_width                    0.5" "supp_proxim_edges_on                 0" \
			  "supp_proxim_edges                    0.5" "combine_nonmanifold_on               0" \
			  "combine_nonmanifold                  0.5" "defeature_ribs_width_on              0" \
			  "defeature_ribs_width                 0.9" "midmesh_extract_elem_size            10" \
			  "remove_logo                          1" "logo_max_size                        30" \
			  "logo_max_height                      1.5" "logo_min_concavity                   2" \
			  "threads_removal                      0" "threads_toremove_max_depth           0" \
			  "threads_replacediametertype          -2" "folded_elems_angle                   150" \
			  "smooth_elems_target                  0.2" "fillets_mesh_flow                    0" \
			  "failed_elems_cleanup_flgs            8" "move_nodes_across_feature_edges      1" \
			  "featureedge_nodes_moveacross_max     L*0.1" "move_nodes_across_free_edges         1" \
			  "freeedge_nodes_moveacross_max        L*0.05" "move_nodes_across_t_edges            0" \
			  "tedge_nodes_moveacross_max           L*0.025" "move_normal_flag                     0" \
			  "move_normal_dist                     10" "divide_warped_quads                  1" \
			  "aggressive_elems_quality_correction  0" "ignore_comps_boundary                0" \
			  "gen_topology_prepare_flags           7" "use_wildcards_for_compsnames         0" \
			  "cleanup_tolerances                   auto" "suppress_features_rate               0" \
			  "feat_charsize_method                 0" "custom_feat_suppr_maxangle           25" \
			  "uncond_constr_lines_suppress         0" "aggressive_fillet_lines_suppress     0"
			*createbatchparamsfromstrings 1 109
			eval *createmark elems 1 $ele_hole
			*createstringarray 2 "elements_on" "geometry_on"
			*isolateonlyentitybymark 1 1 2
			*rebuild_mesh 1
			*clearmark elems 1
			*createmark elems 1 "displayed"
			set list_bnodes [hm_getedgeloops elems markid=1 looptype=2 restricttoinput=1]
			set list_edge1 [lindex $list_bnodes 0]
			set node_new1 [lrange $list_edge1 2 end]
			set list_edge2 [lindex $list_bnodes 1]
			set node_new2 [lrange $list_edge2 2 end]
			set node_check [lindex $node_new1 0]
			set dis [hm_getdistance nodes $node1_shashi $node_check 0]
			set r [lindex $dis 0]
			if {$r <  [expr $r_new + 1] && $r > [expr $r_new - 1] } {
				set node_hole $node_new1
			} else {
				set node_hole $node_new2
			}
			
			foreach node_shashi $node_gotail_shashi {
				set x [hm_getvalue node id = $node_shashi dataname = x]
				set y [hm_getvalue node id = $node_shashi dataname = y]
				set z [hm_getvalue node id = $node_shashi dataname = z]
				*createmark nodes 1 "by sphere" $x $y $z 10 inside 0 1 0
				set node_near [hm_getmark nodes 1]
				set max 15
				foreach node_n $node_near {
					if {[lsearch $node_hole $node_n] > -1 } {
						set dis_check [hm_getdistance nodes $node_shashi $node_n 0]
						set r [lindex $dis_check 0]
						if {$r < $max} {
							set max $r
							set node_ok $node_n
						}
					}
				}
				if {$max != 15} {
					hm_answernext yes
					*replacenodes $node_ok $node_shashi 1 0
					set m [lsearch $node_hole $node_ok]
					set node_hole [lreplace $node_hole $m $m]
				}
			}
		}
		*createmark nodes 1 "by element id" $gotail_shashi
		set node1_shashi [hm_getvalue elems id=$gotail_shashi dataname=node1]
		set n [lsearch $node_gotail_shashi $node1_shashi]
		set node_gotail_shashi [lreplace $node_gotail_shashi $n $n]
		set max 0
		foreach node $node_gotail_shashi {
			set dis_check [hm_getdistance nodes $node1_shashi $node 0]
			set r [lindex $dis_check 0]
			if {$r > $max} {
				set max $r
			}
		}
		eval *createmark nodes 1 $node_gotail_shashi
		*findmark nodes 1 257 1 elements 0 2
		set ele_attack [hm_getmark elements 2]
		set elem_remesh []
		foreach ele $ele_attack {
			*createmark nodes 1 "by elem id" $ele
			set node_check [hm_getmark nodes 1]
			if {[llength $node_check] < 5} {
				*createmark elems 1 $ele
				set cog [hm_getcog elems 1]
				set x [lindex $cog 0]
				set y [lindex $cog 1]
				set z [lindex $cog 2]
				*createnode $x $y $z 0 0 0
				set new_node [hm_latestentityid nodes]
				set dis_check [hm_getdistance nodes $new_node $node1_shashi 0]
				set r_check [lindex $dis_check 0]
				if {$r_check > $max } {
					lappend elem_remesh $ele
				}
			}
		}	
		eval *createmark elements 1 $elem_remesh
		*interactiveremeshelems 1 10 2 2 1 1 2 5
		*set_meshfaceparams 0 5 2 0 0 1 0.5 1 1
		*automesh 0 5 2
		*storemeshtodatabase 1
		*ameshclearsurface
		*putelemstorestore 1 2
		*featureangleset 25
		*setusefeatures 0
		*createmark nodes 1 "all"
		*nodemarkaddtempmark 1
		*nodecleartempmark 
	}
}

 # ##### Ngay 12-06 code phan dong hole ban dau va mo lo moi
proc SingleAndCoupe_gotai {coupe_beam_model_shashi} {
	set coupe_gotail []
	set single_gotail []
	foreach coupe $coupe_beam_model_shashi {
		set node_model [lindex $coupe 0]
		set node_shashi [lindex $coupe 1]
		eval *createmark nodes 1 $node_shashi
		*findmark nodes 1 257 1 elements 0 2
		set ele_shashi [hm_getmark elements 2]
		*clearmark nodes 1
		set rbe2_shashi []
		foreach ele $ele_shashi {
			set configtype [hm_getvalue elems id=$ele dataname=config]
			if {$configtype == 55} {
				lappend rbe2_shashi $ele
			}
		}
		eval *createmark nodes 1 $node_model
		*findmark nodes 1 257 1 elements 0 2
		set ele_model [hm_getmark elements 2]
		*clearmark nodes 1
		set rbe2_model []
		foreach ele $ele_model {
			set configtype [hm_getvalue elems id=$ele dataname=config]
			if {$configtype == 55} {
				lappend rbe2_model $ele
			}
		}
		foreach shashi $rbe2_shashi {
			set node1_shashi [hm_getvalue elems id=$shashi dataname=node1]
			set max 1000
			set model_ok ""
			foreach model $rbe2_model {
				set node1_model [hm_getvalue elems id=$model dataname=node1]
				set dis [hm_getdistance nodes $node1_shashi $node1_model 0]
				set r [lindex $dis 0]
				if {$r <= $max } {
					set max $r
					set model_ok $model
				}
			}
			if {$model_ok != "" && $max < 1} {
				set coupe [list $shashi $model_ok]
				lappend coupe_gotail $coupe
			} else {
				lappend single_gotail $shashi
			}
		}
	}
	return [list $coupe_gotail $single_gotail]
}

proc dele_beam_NG {node_shashi beam_shashi_all} {
	set list_beam_model []
	foreach node_NG $node_shashi {
		set findnode [find_node_cog $node_NG]
		set nodecog [lindex $findnode 0]
		set x [hm_getvalue node id=$nodecog dataname=x]
		set y [hm_getvalue node id=$nodecog dataname=y]
		set z [hm_getvalue node id=$nodecog dataname=z]
		*createmark elems 1 "by config" bar2
		*createstringarray 2 "elements_on" "geometry_on"
		*isolateonlyentitybymark 1 1 2
		*clearmark elems 1
		
		eval *createmark elems 1 $beam_shashi_all
		*createstringarray 2 "elements_on" "geometry_on"
		*hideentitybymark 1 1 2
		*clearmark elems 1
		
		*createmark elems 1 "by sphere" $x $y $z 4 inside 0 0 0
		set ele_vis [hm_getmark elems 1]
		set check 0
		foreach ele $ele_vis {
			set configtype [hm_getvalue elems id=$ele dataname=config]
			if {$configtype == 60} {
				set check 1
				set elem_base $ele
			}
		}
		
		if {$check == 0} {
			eval *createmark nodes 1 $node_NG
			*findmark nodes 1 257 1 elements 0 2
			set el [hm_getmark elements 2]
			eval *createmark elements 1 $el
			*deletemark elements 1
			set n [lsearch $node_shashi $node_NG]
			set node_shashi [lreplace $node_shashi $n $n]
		}
		
		if {$check == 1} {
			set list_beam []
			*createmark elems 1 $elem_base
			*findmark elements 1 257 1 elements 0 2
			set x 1
			set y 0
			set ele_attack [hm_getmark elements 2]
			*clearmark elems 1
			*createmark nodes 1 "by element id" $ele_attack
			set node_attack [hm_getmark nodes 1]
			*clearmark nodes 1
			set a 0
			while {$x != $y} {
				set list1 []
				eval *createmark elem 1 $ele_attack
				*createstringarray 2 "elements_on" "geometry_on"
				*isolateonlyentitybymark 1 1 2
				*findmark elements 1 257 1 elements 1 2
				*createmark elems 1 "displayed"
				set elem1_check [hm_getmark elems 1]
				*clearmark elems 1
				foreach a $elem1_check {
					set configtype [hm_getvalue elems id=$a dataname=config]
					if {$configtype == 60} {
						lappend list1 $a 
					}
				}
				set x [llength $list1]
				eval *createmark elements 1 $list1
				*createstringarray 2 "elements_on" "geometry_on"
				*isolateonlyentitybymark 1 1 2
				*findmark elements 1 257 1 elements 1 2
				*createmark elems 1 "displayed"	
				set elem2_check [hm_getmark elements 1]
				*clearmark elems 1
				set list2 []
				foreach b $elem2_check {
					set configtype [hm_getvalue elems id=$b dataname=config]
					if {$configtype == 60} {
						lappend list2 $b 
					}
				}
				set y [llength $list2]
				set ele_attack $list2
				
				if {$x == $y} {
					set node_beam_model []
					foreach beams $list2 {
						*createmark nodes 1 "by element id" $beams
						foreach node [hm_getmark nodes 1] {
							lappend node_beam_model $node
						}
						*clearmark nodes 1
					}
					set node_beam_model [lsort -unique $node_beam_model]
					set xxx [list $node_beam_model $node_NG]
					lappend list_beam_model $xxx
				}	
			}
		}
	}
	set list_beam_model [lsort -unique $list_beam_model]
	return $list_beam_model
}


proc position_shashi {node_shashi ele_colector} {
	eval *createmark elems 1 $ele_colector
	*createstringarray 2 "elements_on" "geometry_on"
	*isolateonlyentitybymark 1 1 2
	*clearmark elems 
	*createmark nodes 1 "displayed"
	*findmark nodes 1 257 1 elements 0 2
	*clearmark nodes 1
	*createmark elems 1 "displayed"
	set ele_colecor_all [hm_getmark elems 1]
	
	foreach node_sha $node_shashi {
		*createmark elems 1 "by config" bar2
		*createstringarray 2 "elements_on" "geometry_on"
		*isolateonlyentitybymark 1 1 2
		*clearmark elems 1
		*createmark elems 1 "displayed"
		*findmark elements 1 257 1 elements 1 2
	
		set findnode [find_node_cog $node_sha]
		# set nodecog [lindex $findnode 0]
		set node_shashi1 [lindex $findnode 1]
		set node_shashi2 [lindex $findnode 2]
		
		set x [hm_getvalue node id=$node_shashi1 dataname=x]
		set y [hm_getvalue node id=$node_shashi1 dataname=y]
		set z [hm_getvalue node id=$node_shashi1 dataname=z]
		
		eval *createmark elems 1 $ele_colecor_all
		*createstringarray 2 "elements_on" "geometry_on"
		*hideentitybymark 1 1 2
		*clearmark elems 
		
		*createmark elems 1 "by sphere" $x $y $z 4 inside 0 0 0
		set ele_vis [hm_getmark elems 1]
		set max 10000
		set node_cog_beam_model ""
		foreach ele $ele_vis {
			*createmark elements 1 $ele
			*findmark elements 1 257 1 elements 1 2
			set elem_check [hm_getmark elements 2]
			set check 0
			foreach a $elem_check {
				set configtype_check [hm_getvalue elems id=$a dataname=config]
				if {$configtype_check == 60} {
					set check 1
				}
			}
			set configtype [hm_getvalue elems id=$ele dataname=config]
			if {$configtype == 55 && $check == 1} {
				set node_cog_beam_model [hm_getvalue elems id=$ele dataname=node1]
				set dis [hm_getdistance nodes $node_shashi1 $node_cog_beam_model 0]
				set r [lindex $dis 0]
				if {$r <= $max } {
					set max $r
					set node_gotail_ido $node_cog_beam_model
				}
			}
		}
		if {$max < 4} {
			set x1 [hm_getvalue node id=$node_gotail_ido dataname=x]
			set y1 [hm_getvalue node id=$node_gotail_ido dataname=y]
			set z1 [hm_getvalue node id=$node_gotail_ido dataname=z]
			
			set dx [expr $x1 - $x]
			set dy [expr $y1 - $y]
			set dz [expr $z1 - $z]
			
			set comps_all [hm_entitylist comps id]
			eval *createmark components 2 $comps_all
			*createstringarray 2 "elements_on" "geometry_on"
			*hideentitybymark 2 1 2
			*clearmark components 2
			*clearmark nodes 1
			eval *createmark nodes 1 $node_sha
			*findmark nodes 1 257 1 elements 0 2
			*clearmark nodes 1
			*createmark nodes 1 "displayed"
			set node_m [hm_getmark nodes 1]
			eval *createmark nodes 1 $node_m
			if {$dx!=0 || $dy !=0 || $dz !=0} {
				*createvector 1 $dx $dy $dz
				*translatemark nodes 1 1 $max
			}
			move_gotail $node_shashi $ele_colector
		} 
	}
}

proc move_gotail {node_shashi ele_colector} {
	# puts "node $node_shashi"
	# puts "ele $ele_colector"
	eval *createmark elems 1 $ele_colector
	*findmark elements 1 257 1 elements 0 2
	set elem_shashi [hm_getmark elements 2]
	set ele_gotail_shashi []
	foreach ele $elem_shashi {
		set configtype_check [hm_getvalue elems id=$ele dataname=config]
		if {$configtype_check == 55} {
			lappend ele_gotail_shashi $ele
		}
	}
	# puts "gotail $ele_gotail_shashi"
	foreach gotail $ele_gotail_shashi {
		# puts "aaa $gotail"
		*createmark nodes 1 "by elem id" $gotail
		set node_gotail [hm_getmark nodes 1]
		set l1 [llength $node_gotail]
		set max 0
		set node1_gotail [hm_getvalue elems id=$gotail dataname=node1]
		set x1 [hm_getvalue node id=$node1_gotail dataname=x]
		set y1 [hm_getvalue node id=$node1_gotail dataname=y]
		set z1 [hm_getvalue node id=$node1_gotail dataname=z]
		*createmark elems 1 "by sphere" $x1 $y1 $z1 5 inside 0 1 0
		set elem_near [hm_getmark elems 1]
		# puts $elem_near
		set max 10000
		set ele_base ""
		# puts $elem_near
		foreach ele $elem_near {
			set n [lsearch $ele_gotail_shashi $ele]
			set configtype_ele_near [hm_getvalue elems id=$ele dataname=config]
			if {$n == -1 && $configtype_ele_near == 55} {
				set node1_near [hm_getvalue elems id=$ele dataname=node1]
				set dis [hm_getdistance nodes $node1_gotail $node1_near 0]
				set r [lindex $dis 0]
				# puts "rrr $r $n $ele $gotail"
				if {$r <= $max } {
					set max $r
					set node_base $node1_near
					set ele_base $ele
				}
			}
		}
		# puts "maxxxxx $max"
		if {$max < 4} {
			# puts "$gotail $ele_base $max"
			set node1_base [hm_getvalue elems id=$ele_base dataname=node1]
			set x2 [hm_getvalue node id=$node1_base dataname=x]
			set y2 [hm_getvalue node id=$node1_base dataname=y]
			set z2 [hm_getvalue node id=$node1_base dataname=z]
			
			set dx [expr $x2 - $x1]
			set dy [expr $y2 - $y1]
			set dz [expr $z2 - $z1]
			# puts "$max $node_gotail"
			eval *createmark nodes 1 $node_gotail
			# puts "dx dyx dz $dx $dy $dz"
			if {$dx!=0 || $dy !=0 || $dz !=0} {
				*createvector 1 $dx $dy $dz
				*translatemark nodes 1 1 $max
			}
		}
	}
}


proc find_node_cog {list_id_node} {
	set l [llength $list_id_node]
	set max 0
	for {set i 0} {$i < $l} {incr i} {
		set node1 [lindex $list_id_node $i]
		for {set j 0} {$j < $l} {incr j} {
			set node2 [lindex $list_id_node $j]
			set dis [hm_getdistance nodes $node1 $node2 0]
			set r [lindex $dis 0]
			if {$r >= $max } {
				set max $r
				set node_start $node1
				set node_end $node2
			}
		}
	}
	*createnodesbetweennodes $node_start $node_end 1
	set node_cog [hm_latestentityid nodes]
	return [list $node_cog $node_start $node_end]
}

proc find_node_beam {list_beams} {
	set list_node_beam []
	foreach beams $list_beams {
		set node_beams []
		foreach beam $beams {
			*createmark nodes 1 "by element id" $beam
			foreach node [hm_getmark nodes 1] {
				lappend node_beams $node
			}
			*clearmark nodes 1
		}
		set node_beams [lsort -unique $node_beams]
		lappend list_node_beam $node_beams
	}
	return $list_node_beam
}


proc input_beam_shashi {support_folder} {
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
	# "C:/Users/KNT20993/Desktop/FY24/2.GK210_BIW/beamtest1.nas"
	set input_file_beam "$support_folder/Shashi/beam.nas"
	*feinputpreserveincludefiles 
	*createstringarray 13 "Nastran " "NastranMSC " "ANSA " "PATRAN " "SPC1_To_SPC " \
		  "EXPAND_IDS_FOR_FORMULA_SETS " "HM_READ_PCL_GRUPEE_COMMENTS " "ASSIGNPROP_BYHMCOMMENTS" \
		  "LOADCOLS_DISPLAY_SKIP " "VECTORCOLS_DISPLAY_SKIP " "SYSTCOLS_DISPLAY_SKIP " \
		  "CONTACTSURF_DISPLAY_SKIP " "IMPORT_MATERIAL_METADATA"
	*feinputwithdata2 "\#nastran\\nastran" $input_file_beam 0 0 0 0 0 1 13 1 0
	*createmark elems 1 "by config" rigidlink
	*createstringarray 2 "elements_on" "geometry_on"
	*hideentitybymark 1 1 2
	*clearmark elems 1
}

proc find_beam_model {elem} {
	set ele_ok []
	set list_ele []
	foreach ele $elem {
		set idb [lsearch $ele_ok $ele]
		if {$idb == -1} {
			*createmark elem 1 $ele
			*createstringarray 2 "elements_on" "geometry_on"
			*isolateonlyentitybymark 1 1 2
			set x 1
			set y 0
			while {$x != $y}  { 
				set list1 []
				*createmark elems 1 "displayed"
				foreach a [hm_getmark elems 1] {
					set configtype [hm_getvalue elems id=$a dataname=config]
					set check [lsearch $elem $a]
					if {$configtype == 60 && $check != -1 } {
						lappend list1 $a 
					}
				}
				# puts "list1 $list1"
				set x [llength $list1]
				*clearmark elems 1
				eval *createmark elements 1 $list1
				*createstringarray 2 "elements_on" "geometry_on"
				*isolateonlyentitybymark 1 1 2
				*findmark elements 1 257 1 elements 1 2
				*clearmark elements 1
				*createmark elems 1 "displayed"
				
				set list2 []
				foreach b [hm_getmark elems 1] {
					set configtype [hm_getvalue elems id=$b dataname=config]
					set check2 [lsearch $elem $b]
					if {$configtype == 60 && $check2 != -1} {
						lappend list2 $b 
					}
				}
				*clearmark elements 1
				set y [llength $list2]
				# puts "list2 $list2"
				if {$x == $y} {
					foreach ele $list2 {
						lappend ele_ok $ele
					}
					lappend list_ele $list2
				} else {
					eval *createmark elements 1 $list2
					*createstringarray 2 "elements_on" "geometry_on"
					*isolateonlyentitybymark 1 1 2
					*findmark elements 1 257 1 elements 1 2	
					*clearmark elements 1
				}
			}
		}
	}
	set list_ele [lsort -unique $list_ele]
	return $list_ele
}

# ### --- end tool beam shashi ----------

# ####

proc run_ansa {ansa_ver support_folder} {
	global input
	set py_macro_base "$support_folder/CutModel.py"
	set readfile_base [open $py_macro_base r]
	set lines [read $readfile_base]
	close $readfile_base
	set code_py [string map "_EXCEL-LINK_ $input" $lines]
	
	set py_macro_run "$support_folder/CutModel_run.py"
	set writefile [open $py_macro_run w]
	puts $writefile $code_py
	close $writefile
	set a [exec cmd /c $ansa_ver -execscript $py_macro_run]
	file delete $py_macro_run
}

proc export_master {output_name input_folder} {
	*EntityPreviewEmpty components 1
	set comp_empty [hm_getmark components 1]
	if { [llength $comp_empty] > 0 } {
		eval *createmark components 1 $comp_empty
		*deletemark components 1
	}
	*retainmarkselections 0
	*createstringarray 4 "HM_REAL_VALUES_E_OPTION " "HM_NODEELEMS_SET_COMPRESS_SKIP " \
	"EXPORT_SYSTEM_LONGFORMAT " "HMBOMCOMMENTS_XML"
	hm_answernext yes
	set template [hm_info -appinfo SPECIFIEDPATH TEMPLATES_DIR]
	puts "$output_name"
	*feoutputwithdata "$template/feoutput/nastran/general" "$output_name" 0 0 1 1 4
	set list_fo [split $output_name "/"]
	# set len [llength $spli_vip]
	# set list_fo [lreplace $list_fo $len $len]
	set list_fo [lrange $list_fo 0 end-1]
	set output_folder [join $list_fo "/"]
	
	set files [glob -directory $input_folder -- *]
	foreach file $files {
		if {[string first ".vip" $file] != -1 } {
			set spli_vip [split $file "/"]
			set len_vip [llength $spli_vip]
			set name_vip [lindex $spli_vip [expr $len_vip - 1]]
			if {[file exists "$output_folder/$name_vip"] == 1} {
				continue
			} else {
				file copy $file "$output_folder/$name_vip"
			}
		}
	}
	
}

proc create_plot {list_plot} {
	*createmark nodes 1 "all"
	*nodemarkaddtempmark 1
	*nodecleartempmark 
	set comps [hm_entitylist comps id]
	eval *createmark components 2 $comps
	*createstringarray 2 "elements_on" "geometry_on"
	*hideentitybymark 2 1 2
	*clearmark components 2
			
	foreach item $list_plot {
		set id [lindex $item 0]
		set name [lindex $item 1]
		*createmark comps 2 "by id on ly" $id
		set comp_name_check [hm_getmark comps 2]
		if {! [Null comp_name_check]} {
			set comp_name [hm_getvalue comp id=$comp_name_check dataname=name]
			if {$comp_name != $name} {
				*setvalue comps id=$id name=$name
			}
			*currentcollector components $name
		} else {
			*createentity comps id=$id name=$name
		}
		set coords [lindex $item 2]
		set list_coord [split $coords "@"]
		set list_id_node []
		foreach co $list_coord {
			set xyz [split $co ","]
			set x [lindex $xyz 0]
			set y [lindex $xyz 1]
			set z [lindex $xyz 2]
			set node_ok [find_node $x $y $z]
			lappend list_id_node $node_ok
		}
		
		eval *createmark nodes 1 $list_id_node
		*findmark nodes 1 1 1 components 0 2
		set comps [hm_getmark components 2]
		eval *createmark components 2 $comps
		*createstringarray 2 "elements_on" "geometry_on"
		*isolateonlyentitybymark 2 1 2
		*clearmark components 2
			
		set l [llength $list_id_node]
		set max 0
		for {set i 0} {$i < $l} {incr i} {
			set node1 [lindex $list_id_node $i]
			for {set j 0} {$j < $l} {incr j} {
				set node2 [lindex $list_id_node $j]
				set dis [hm_getdistance nodes $node1 $node2 0]
				set r [lindex $dis 0]
				if {$r > $max } {
					set max $r
					set node_start $node1
					set node_end $node2
				}
			}
		}
		# set list_id_node [linsert $list_id_node 1 $node_start]
		lappend list_id_node $node_end
		set list_ok [list $node_start]
		set l [llength $list_id_node]
		set len 1
		for {set i 0} {$i < $len} {incr i} { 
			set node_current [lindex $list_ok $i]
			set min 100000
			set node_ok ""
			for {set j 0} {$j < [llength $list_id_node]} {incr j} {
				set node_check [lindex $list_id_node $j]
				set check [lsearch $list_ok $node_check]
				if {$check < 0} {
					set dis [hm_getdistance nodes $node_current $node_check 0]
					set r [lindex $dis 0]
					if {$r < $min} {
						set min $r
						set node_ok $node_check
					}
				}
			}
			if {$node_ok != ""} {
				lappend list_ok $node_ok
				set len [expr $len +1]
			}
		}
		
		puts $list_ok
		for {set i 0} {$i < [expr [llength $list_ok] -1 ]} {incr i} { 
			set node1 [lindex $list_ok $i]
			set j [expr $i +1]
			set node2 [lindex $list_ok $j]
			*nodemarkbypath $node1 $node2 1
			set a [hm_getmark node 1]
			if {[llength $a] < 2} {
				*createlist nodes 1 $node1 $node2
			} else {
				*nodelistbypath $node1 $node2 1 
			}
			*createelement 2 1 1 1
			*createmark nodes 1 "all"
			*nodemarkaddtempmark 1
			*nodecleartempmark 
		
		}
	}
}

proc find_node {x y z} {
	*createmark nodes 1 "by sphere" $x $y $z 1 inside 0 1 0
	set nodes_check [hm_getmark nodes 1]
	*createnode $x $y $z 0 0 0
	set node_base [hm_latestentityid nodes]
	set node_ok ""
	set min 1
	foreach node $nodes_check {
		set dis_min [hm_getdistance nodes $node $node_base 0]
		if {[lindex $dis_min 0] < $min} {
			set node_ok $node
			set min $dis_min
		}
	}
	*createmark nodes 1 "all"
	*nodemarkaddtempmark 1
	*nodecleartempmark 
	return $node_ok
}

proc readFilesAndFolders {folderPath} {
    set folders [glob -directory $folderPath * ]
	set inclue_all []
    foreach folder $folders {
        if {[file isdirectory $folder] == 1} {
			set files [glob -directory $folder *]
			foreach file $files {
				set folderName [file tail $folder]
				set fileName [file tail $file]
				set length [string length $fileName]
				set check_character [string range $fileName [expr $length - 3] $length]
				if {$check_character == "bdf" || $check_character == "nas" } {
					set a []
					lappend a $folderName
					lappend a $fileName
					lappend inclue_all $a
				}
			}
        } 
    }
	return  $inclue_all
}

proc create_incule {inclue_all} {	
	set txt []
	foreach inclue $inclue_all {
		set folder [lindex $inclue 0]
		set file [lindex $inclue 1]
		set x "$folder/$file"
		lappend txt "INCLUDE '$x'"
	}
	# puts $txt
	set new_file_dat "C:/Users/KNT20993/Desktop/FY24/2.GK210_BIW/P33C/Base/P33C-ePWR/inclue_test.dat"
	set writefile [open $new_file_dat w]
	puts $writefile [join $txt "\n"]
	close $writefile
	
	*feinputpreserveincludefiles 
	*createstringarray 13 "Nastran " "NastranMSC " "ANSA " "PATRAN " "SPC1_To_SPC " \
	  "EXPAND_IDS_FOR_FORMULA_SETS " "HM_READ_PCL_GRUPEE_COMMENTS " "ASSIGNPROP_BYHMCOMMENTS" \
	  "LOADCOLS_DISPLAY_SKIP " "VECTORCOLS_DISPLAY_SKIP " "SYSTCOLS_DISPLAY_SKIP " \
	  "CONTACTSURF_DISPLAY_SKIP " "IMPORT_MATERIAL_METADATA"
	*feinputwithdata2 "\#nastran\\nastran" $new_file_dat 0 0 0 0 0 1 13 1 0
}

proc create_ass {inclue_all list_ass} {
	set ass_all [hm_entitylist assemblies id]
	if { $ass_all != "" } {
		eval *createmark assemblies 1 $ass_all
		*deletemark assemblies 1
	}
	
	
	set loadcol_all [hm_entitylist loadcols id]
	if {$loadcol_all != "" } {
		eval *createmark loadcols 1 $ass_all
		*deletemark loadcols 1
	}
	
	set comp_all [hm_entitylist comps id]
	eval *createmark comps 1 $comp_all
	# *autocolorwithmark components 1
	foreach ass $list_ass { 
		set id [lindex $ass 0] 
		set categorys [lindex $ass 2] 
		set assename [lindex $ass 1]
		*createentity assems includeid=$id name=$assename
		set id_ass [hm_latestentityid assems]
		*setvalue assems id=$id_ass id={assems $id}
		set comp_all []
		foreach cate $categorys {	
			foreach inclue $inclue_all {
				set folder [lindex $inclue 0]
				set inclue_file [lindex $inclue 1]
				if {$cate == $folder} {
					*createmark comp 1 "by include shortname" $inclue_file
					set comps [hm_getmark comp 1]		
					foreach comp $comps {
						lappend comp_all $comp
					}
				}
			}
		}
		# puts $comp_all
		*setvalue assems id=$id components={comps $comp_all}
	}

}



proc create_gotail {support_folder} {
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
	
	set file_renumber "$support_folder/gotail.nas"
	*feinputpreserveincludefiles 
	*createstringarray 13 "Nastran " "NastranMSC " "ANSA " "PATRAN " "SPC1_To_SPC " \
	  "EXPAND_IDS_FOR_FORMULA_SETS " "HM_READ_PCL_GRUPEE_COMMENTS " "ASSIGNPROP_BYHMCOMMENTS" \
	  "LOADCOLS_DISPLAY_SKIP " "VECTORCOLS_DISPLAY_SKIP " "SYSTCOLS_DISPLAY_SKIP " \
	  "CONTACTSURF_DISPLAY_SKIP " "IMPORT_MATERIAL_METADATA"
	*feinputwithdata2 "\#nastran\\nastran" $file_renumber 0 0 0 0 0 1 13 1 0
	*createmark elements 1 "displayed"
	set gotail [hm_getmark elements 1]
	set comps_all [hm_entitylist comps id]
	eval *createmark components 1 $comps_all
	*equivalence components 1 0.01 1 0 0
	
	# foreach ele $gotail {
		# set node1 [hm_getvalue elems id=$ele dataname=node1]
		# *createmark nodes 1 "by elem id" $ele
		# set node_ele [hm_getmark nodes 1]
		# set pos [lsearch -all $node_ele $node1]
		# set node_ele [lreplace $node_ele $pos $pos]
		# set node_rm []
		# foreach n $node_ele {
			# *createmark nodes 1 $n
			# *findmark nodes 1 257 1 elements 1 2
			# set elem_att [hm_getmark elements 2]
			# if {[llength $elem_att] == 1} {
				# lappend node_rm $n
			# }
		# }
		# foreach node $node_rm {
			# set pos [lsearch -all $node_ele $node]
			# if {$pos > -1} {
				# set node_ele [lreplace $node_ele $pos $pos]
			# }
		# }
		# puts $ele
		# puts $node_ele
		# eval *createmark nodes 1 $node_ele
		# *rigidlinkupdate $ele $node1 1
	# }
	*numbersclear 
}


proc read_input_sheet4 {} {
	puts "Run read_input_sheet4"
	puts "------------------"
	global input 
	set excel_file $input
	package require twapi
	set excel [::twapi::comobj Excel.Application]
	$excel DisplayAlerts [expr 0]
	set workbooks [$excel Workbooks]
	$workbooks Open "$excel_file"
	set workbook [$workbooks Item 1]
	set sheets [$workbook Sheets]
	set sheet [$sheets Item 4]
	set cells [$sheet Cells]

	set inputsheet []
	set input_renumber []
	for {set i 8} {$i < 1000} {incr i} { 
		set a []
		if {[[$sheet range b$i] Value] == ""} {
			break
		}
		set id [[$sheet range b$i] Value]
		set coord [[$sheet range c$i] Value]
		lappend a $id
		lappend a $coord
		lappend input_renumber $a
	}
	set input_createRbe2 []
	for {set i 8} {$i < 1000} {incr i} { 
		set b []
		if {[[$sheet range f$i] Value] == ""} {
			break
		}
		set id_comp [[$sheet range f$i] Value]
		set nodecog [[$sheet range g$i] Value]
		set pid [[$sheet range h$i] Value]
		set type [[$sheet range i$i] Value]
		set coord1 [[$sheet range j$i] Value]
		set coord2 [[$sheet range k$i] Value]
		set coord3 [[$sheet range l$i] Value]
		set node_rm [[$sheet range M$i] Value]
		set node_add [[$sheet range M$i] Value]
		
		lappend b $id_comp
		lappend b $nodecog
		lappend b $pid
		lappend b $type
		lappend b $coord1
		lappend b $coord2
		lappend b $coord3
		lappend b $node_rm
		lappend b $node_add
		
		lappend input_createRbe2 $b
	}
	
	set input_ass []
	for {set i 8} {$i < 100} {incr i} { 
		set c []
		if {[[$sheet range p$i] Value] == ""} {
			break
		}
		set id_ass [[$sheet range p$i] Value]
		set name [[$sheet range q$i] Value]
		set cate_all [[$sheet range R$i] Value]
		set cates [split $cate_all ","]	
		lappend c $id_ass
		lappend c $name
		lappend c $cates
		# foreach cate $cates {
			# lappend c $cate
		# }
		
		lappend input_ass $c
	}
	
	set input_plot []
	for {set i 8} {$i < 100} {incr i} { 
		set d []
		if {[[$sheet range u$i] Value] == ""} {
			break
		}
		set id_plot [[$sheet range u$i] Value]
		set name_plot [[$sheet range v$i] Value]
		set coord_plot [[$sheet range w$i] Value]
		lappend d $id_plot
		lappend d $name_plot
		lappend d $coord_plot
		
		lappend input_plot $d
	}
	
	set folder_cut []
	for {set i 8} {$i < 100} {incr i} { 
		if {[[$sheet range AA$i] Value] == ""} {
			break
		}
		set name [[$sheet range z$i] Value]
		set assem_rm [[$sheet range AF$i] Value]
		if {$name != ""} {
			set m [list $name $assem_rm]
			lappend folder_cut $m
		}
	}
	

	
	lappend inputsheet $input_renumber
	lappend inputsheet $input_createRbe2
	lappend inputsheet $input_ass
	lappend inputsheet $input_plot
	lappend inputsheet $folder_cut
	$workbook Close
	$excel Quit
	$cells -destroy
	$sheet -destroy
	$sheets -destroy
	$workbook -destroy
	$workbooks -destroy
	$excel -destroy
	
	unset excel
	return $inputsheet
}

proc read_input_sheet3 {} {
	global input 
	set excel_file $input
	package require twapi
	set excel [::twapi::comobj Excel.Application]
	$excel DisplayAlerts [expr 0]
	set workbooks [$excel Workbooks]
	$workbooks Open "$excel_file"
	set workbook [$workbooks Item 1]
	set sheets [$workbook Sheets]
	set sheet [$sheets Item 3]
	set cells [$sheet Cells]

	
	set folder_input [[$sheet range q10] Value]
	set ansa_ver [[$sheet range q12] Value]
	set output [[$sheet range d10] Value]
	set sp_foder [[$sheet range d12] Value]
	set op_CB [[$sheet range d18] Value]
	set inputsheet []
	lappend inputsheet $folder_input
	lappend inputsheet $ansa_ver
	lappend inputsheet $output
	lappend inputsheet $sp_foder
	lappend inputsheet $op_CB
	$workbook Close
	$excel Quit
	$cells -destroy
	$sheet -destroy
	$sheets -destroy
	$workbook -destroy
	$workbooks -destroy
	$excel -destroy
	
	unset excel
	return $inputsheet
}


::NTV::main_GUI
