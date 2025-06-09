proc main_GUI {} {
	global glo ; global filemodel; global outputfolder; global supportfolder; global selected_option;global idcog;global node_id , base
	global current_tab ;global 	tab1, tab2, gui
	set base .tool1;
	toplevel $base;
	::hwt::KeepOnTop $base
	wm attribute $base -toolwindow 0
	wm title $base "MASTER ä½œæˆ";
	wm geometry $base 500x350;
	#Create a master frame
	set master_frame [frame $base.master_frame];
	pack $master_frame -side top -anchor nw -padx 7 -pady 7 -expand 1 -fill both;

	set gui(f1) [frame $master_frame.f1]
	pack $gui(f1) -side top -padx 2 -pady 2 -expand 0 -fill x
		set gui(frame1) [frame $gui(f1).frame1]
		pack $gui(frame1) -side top -padx 0 -pady 0 -expand 0 -fill x
			set gui(ent_open_model) [entry $gui(frame1).ent_open_model -textvariable glo(path_file) ]
			pack $gui(ent_open_model) -side right -padx 10 -pady 0 -expand 1 -fill x 
			set gui(but_open_model) [button $gui(frame1).but_open_model -text "File output(*.txt)" -font {{Arial} 9 bold} -background green -width 14 -command "open_file file"]
			pack $gui(but_open_model) -side left -padx 5 -pady 0 -fill y
		
		set gui(frame2) [frame $gui(f1).frame2]
		pack $gui(frame2) -side top -padx 0 -pady 15 -expand 0 -fill x
			ttk::notebook $gui(frame2).notebook
			pack $gui(frame2).notebook -fill both -expand 1
			set tab1 [frame $gui(frame2).notebook.tab1]
			set tab2 [frame $gui(frame2).notebook.tab2]
			set tab3 [frame $gui(frame2).notebook.tab3]
			
			## tab 1
			$gui(frame2).notebook add $tab1 -text "è©•ä¾¡ç‚¹è¨­å®š"
				set gui(id) [entry $tab1.id -textvariable glo(id)] 
				pack $gui(id) -side right -padx 7 -pady 10 -expand 1 -fill x
				set gui(lable1) [label $tab1.lable1 -text "ID RE_NUMBER: " -font {{Arial} 9 bold} -width 15]
				pack $gui(lable1) -side left -padx 5 -pady 10 -fill y
				
			### tab 2
			$gui(frame2).notebook add $tab2 -text "å¢ƒç•Œæ¡ä»¶ç”¨å‰›ä½“è¨­å®š" 		
				set frame21 [frame $tab2.frame21]
				pack $frame21 -side top -padx 0 -pady 5 -expand 0 -fill x
					set idcomp [entry $frame21.id -textvariable glo(comp_create)] 
					pack $idcomp -side right -padx 7 -pady 0 -expand 1 -fill x
					set lable_comp [label $frame21.lable_comp -text "ID COMP CREATE: " -font {{Arial} 9 bold} -width 15]
					pack $lable_comp -side left -padx 5 -pady 0 -fill y
					
				set frame22 [frame $tab2.frame22]
				pack $frame22 -side top -padx 0 -pady 5 -expand 0 -fill x
					set idcog [entry $frame22.idcog -textvariable glo(idcog)] 
					pack $idcog -side right -padx 7 -pady 0 -expand 1 -fill x
					set node_id [label $frame22.node_id -text "COG ID: " -font {{Arial} 9 bold} -width 15]
					pack $node_id -side left -padx 5 -pady 0 -fill y
					
				set frame20 [frame $tab2.frame20]
				pack $frame20 -side top -padx 0 -pady 5 -expand 0 -fill x
					set comp [entry $frame20.comp -textvariable glo(pids) ]
					pack $comp -side right -padx 15 -pady 0 -expand 1 -fill x 
					set button_com [button $frame20.button_com -text "PID (node): " -command "pick_comp" -font {{Arial} 9 bold} -background red -width 10]
					pack $button_com -side left -padx 20 -pady 0 -fill y
				
				set frame23 [frame $tab2.frame23]
				pack $frame23 -side top -padx 0 -pady 5 -expand 0 -fill x				
					frame $frame23.radios
					pack $frame23.radios -padx 0 -pady 0	
					set selected_option ""
					radiobutton $frame23.radios.option1 -text "QUARE" -variable selected_option -value "QUARE" -font {{Arial} 9 bold} -width 15
					pack $frame23.radios.option1 -side left -padx 0 -pady 0
					radiobutton $frame23.radios.option2 -text "ROUND2" -variable selected_option -value "ROUND2" -font {{Arial} 9 bold} -width 15
					pack $frame23.radios.option2 -side left -padx 2 -pady 0
					radiobutton $frame23.radios.option3 -text "ROUND3" -variable selected_option -value "ROUND3" -font {{Arial} 9 bold} -width 15
					pack $frame23.radios.option3 -side left -padx 4 -pady 0	
					$frame23.radios.option1 select
				
				set frame24 [frame $tab2.frame24]
				pack $frame24 -side top -padx 0 -pady 5 -expand 0 -fill x
					set button_pick [button $frame24.button_pick -text "Pick(3 node)" -command "pick_node" -font {{Arial} 9 bold} -background cyan -width 12]
					pack $button_pick -side left -padx 20 -pady 0 -fill y
					set button_remove [button $frame24.button_remove -text "Remove(node)" -command "remove_node" -font {{Arial} 9 bold} -background magenta -width 12]
					pack $button_remove -side left -padx 20 -pady 0 -fill y
					set button_add [button $frame24.button_add -text "Add(node)" -command "add_node" -font {{Arial} 9 bold} -background yellow -width 12]
					pack $button_add -side left -padx 20 -pady 0 -fill y
						
				set frame25 [frame $tab2.frame25]
				pack $frame25 -side top -padx 0 -pady 5 -expand 0 -fill x
					set elem_id [entry $frame25.elem_id -textvariable glo(ele_id) -state disabled -width 8] 
					pack $elem_id -side left -padx 5 -pady 0 -expand 1 -fill x	
					set id_node [entry $frame25.id_node -textvariable glo(id_node)  -state disabled -width 8] 
					pack $id_node -side left -padx 5 -pady 0 -expand 1 -fill x
					set id_remove [entry $frame25.id_remove -textvariable glo(id_remove) -state disabled -width 8] 
					pack $id_remove -side left -padx 5 -pady 0 -expand 1 -fill x
					set id_add [entry $frame25.id_add -textvariable glo(id_add) -state disabled -width 8] 
					pack $id_add -side left -padx 5 -pady 0 -expand 1 -fill x
					
				#tab 3	
				$gui(frame2).notebook add $tab3 -text "PLOTED"
					set frame31 [frame $tab3.frame31]
					pack $frame31 -side top -padx 0 -pady 5 -expand 0 -fill x
						set gui(idplot) [entry $frame31.idplot -textvariable glo(idplot)] 
						pack $gui(idplot) -side right -padx 3 -pady 10 -expand 1 -fill x
						set gui(lable31) [label $frame31.lable31 -text "PID PLOT: " -font {{Arial} 9 bold} -width 15]
						pack $gui(lable31) -side left -padx 3 -pady 10 -fill y
						
					### mai sua phan nay
					set frame32 [frame $tab3.frame32]
					pack $frame32 -side top -padx 0 -pady 30 -expand 0 -fill x
						set button_pickp [button $frame32.button_pickp -text "Pick" -command "pick_node_plot" -font {{Arial} 9 bold} -background cyan -width 12]
						pack $button_pickp -side left -padx 10 -pady 0 -expand 1 -fill x
						set button_edit [button $frame32.button_edit -text "Edit" -command "button_edit" -font {{Arial} 9 bold} -background cyan -width 12]
						pack $button_edit -side left -padx 5 -pady 0 -expand 1 -fill x
					set frame33 [frame $tab3.frame33]
					pack $frame33 -side top -padx 0 -pady 5 -expand 0 -fill x	
						set id_node [entry $frame33.id_node -textvariable glo(idnode_tab3) -state disabled -width 8] 
						pack $id_node -side left -padx 5 -pady 0 -expand 1 -fill x
						set coord_node [entry $frame33.coord_node -textvariable glo(coord_tab3) -state disabled -width 8] 
						pack $coord_node -side left -padx 5 -pady 0 -expand 1 -fill x
				
	
  set buttons_frame [frame $master_frame.buttons_frame];
   pack $buttons_frame -side top -anchor nw -expand 1 -fill both;

      set accept_button [button $buttons_frame.accept \
         -text "OUTPUT TXT" \
         -relief raised \
         -command "Run"\
		 -font {{Arial} 9 bold} \
		 -background #7484BE\
		 -height 3\
		 -width 15];

      set cancel_button [button $buttons_frame.cancel \
         -text "Cancel" \
         -relief raised \
         -command "destroy $base"\
		 -font {{Arial} 9 bold} \
		 -background #7484BE\
		 -height 3\
		 -width 15];
      pack $accept_button -side left -anchor se -padx 10;
	  pack $cancel_button -side right -anchor se -padx 10;	
	  
	bind $gui(frame2).notebook <<NotebookTabChanged>> {
		global gui, current_tab
		set current_tab [$gui(frame2).notebook select]
	}
	set glo(id) ""
	#tab2
	set glo(pids) ""
	set glo(comp_create) ""
	set glo(idcog) ""
	set glo(id_node) ""
	set glo(id_add) ""
	set glo(id_remove) ""
	set glo(ele_id) ""
	## tab3
	set glo(idnode_tab3) ""
	set glo(coord_tab3) ""
	set glo(idplot) ""
}
proc Run {} { 
	variable gui; global glo; global selected_option;global node_id; global idcog ; global current_tab; 
	set filepc $glo(path_file)
	if {$current_tab == ".tool1.master_frame.f1.frame2.notebook.tab1"} {
		table1_func_renumbernode
	} elseif {$current_tab == ".tool1.master_frame.f1.frame2.notebook.tab2"} {
		set file_data "$filepc"
		set writefile1 [open $file_data a]
		set data "tab2/$glo(comp_create)/$glo(idcog)/$glo(pids)/$selected_option/$glo(id_node)/$glo(id_remove)/$glo(id_add)"
		puts $data
		puts $writefile1 $data
		close $writefile1
	} elseif {$current_tab == ".tool1.master_frame.f1.frame2.notebook.tab3"} {
		set file_data "$filepc"
		set writefile1 [open $file_data a]
		set data "tab3/$glo(idplot)/$glo(coord_tab3)"
		puts $data
		puts $writefile1 $data
		close $writefile1
		*createmark components 1 "comp check plot"
		*deletemark components 1
	}
	set glo(id) ""
	set glo(comp_create) ""
	#tab2
	set glo(id_node) ""
	set glo(idcog) ""
	set glo(pids) ""
	set glo(data2) ""
	set glo(ele_id) ""
	set glo(id_remove) ""
	set glo(id_add) ""
	set glo(idnode_tab3) ""
	set glo(coord_tab3) ""
	set glo(idplot) ""
}

proc button_edit {} {
	*createmark nodes 1 "all"
	*nodemarkaddtempmark 1
	*nodecleartempmark 
	variable gui; variable arr; global glo
	set list_nodep [join $glo(idnode_tab3) ","]
	*createmark components 2 $list_nodep
	*createmarkpanel nodes 1
	set node_edit [hm_getmark nodes 1]
	*createmark components 1 "comp check plot"
	*deletemark components 1
	set node_str [join $node_edit ","]
	set glo(idnode_tab3) "$glo(idnode_tab3),$node_str"
	set list_coord []
	foreach node_c $node_edit {
		set x [hm_getvalue node id=$node_c dataname=x]
		set y [hm_getvalue node id=$node_c dataname=y]
		set z [hm_getvalue node id=$node_c dataname=z]
		lappend list_coord "$x,$y,$z"
	}
	set coord_str [join $list_coord "@"]
	set glo(coord_tab3) "$glo(coord_tab3)@$coord_str"
	*createentity comps includeid=0 name="comp check plot"
	set list_id_node [split $glo(idnode_tab3) ","]
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
	set list_id_node [linsert $list_id_node 1 $node_start]
	lappend list_id_node $node_end
	set list_ok []
	set l [llength $list_id_node]
	for {set i 0} {$i < $l} {incr i} {
		set node1 [lindex $list_id_node $i]
		lappend list_ok $node1
		set min 100000
		for {set j 0} {$j < $l} {incr j} {
			set node_check [lindex $list_id_node $j]
			set dis [hm_getdistance nodes $node1 $node_check 0]
			set r [lindex $dis 0]
			set check [lsearch $list_ok $node_check]
			if {$r < $min && $check == -1} {
				set min $r
				set node2 $node_check
			}
		}
		lappend list_ok $node2
		if {$node1 != $node2} {
			*nodemarkbypath $node1 $node2 1
			set a [hm_getmark node 1]
			if {[llength $a] < 2} {
				*createlist nodes 1 $node1 $node2
			} else {
				*nodelistbypath $node1 $node2 1 
			}
		*createelement 2 1 1 1
		}
	}
	*createmark nodes 1 "all"
	*nodemarkaddtempmark 1
	*nodecleartempmark 
}

proc pick_node_plot {} {
	variable gui; variable arr; global glo
	set glo(idnode_tab3) ""
	set glo(coord_tab3) ""
	*createmark nodes 1 "all"
	*nodemarkaddtempmark 1
	*nodecleartempmark 
	*createmarkpanel nodes 1
	set node_pick3 [hm_getmark nodes 1]
	
	set glo(idnode_tab3) [join $node_pick3 ","]
	set list_coord []
	foreach node_c $node_pick3 {
		set x [hm_getvalue node id=$node_c dataname=x]
		set y [hm_getvalue node id=$node_c dataname=y]
		set z [hm_getvalue node id=$node_c dataname=z]
		lappend list_coord "$x,$y,$z"
	}
	set glo(coord_tab3) [join $list_coord "@"]
	*createmark components 1 "comp check plot"
	set comp_name_check [hm_getmark components 1]
	if {! [Null comp_name_check]} {
		*deletemark components 1
	}
	*createentity comps includeid=0 name="comp check plot"
	set list_id_node $node_pick3
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
	set list_id_node [linsert $list_id_node 1 $node_start]
	lappend list_id_node $node_end
	set list_ok []
	set l [llength $list_id_node]
	for {set i 0} {$i < $l} {incr i} {
		set node1 [lindex $list_id_node $i]
		lappend list_ok $node1
		set min 100000
		for {set j 0} {$j < $l} {incr j} {
			set node_check [lindex $list_id_node $j]
			set dis [hm_getdistance nodes $node1 $node_check 0]
			set r [lindex $dis 0]
			set check [lsearch $list_ok $node_check]
			if {$r < $min && $check == -1} {
				set min $r
				set node2 $node_check
			}
		}
		if {$node1 != $node2} {
			*nodemarkbypath $node1 $node2 1
			set a [hm_getmark node 1]
			if {[llength $a] < 2} {
				*createlist nodes 1 $node1 $node2
			} else {
				*nodelistbypath $node1 $node2 1 
			}
			*createelement 2 1 1 1
			*clearmark nodes 1
		}
	}
	*createmark nodes 1 "all"
	*nodemarkaddtempmark 1
	*nodecleartempmark 
}
proc open_file {mode} {
	variable gui; variable arr; global glo
	if {$mode =="outputfolder" || $mode == "supportfolder"} {
		set glo(path_$mode) [tk_chooseDirectory] 
	} else {
		set glo(path_$mode) [tk_getOpenFile]
	}
}
proc pick_comp {} {
	variable gui; variable arr; global glo
	*createmarkpanel comps 1
	set comp [hm_getmark comps 1]
	set glo(pids) [join $comp ","]
	*clearmark comps 1
}
proc add_node {} {
	variable gui; variable arr; global glo
	*createmarkpanel node 1
	set node_add [hm_getmark node 1]
	set node_a []
	*createmark nodes 1 "by elem id" $glo(ele_id)
	set node_old [hm_getmark nodes 1]
	foreach nodea $node_add {
		set x [hm_getvalue node id=$nodea dataname=x]
		set y [hm_getvalue node id=$nodea dataname=y]
		set z [hm_getvalue node id=$nodea dataname=z]
		lappend node_a "$x,$y,$z"
		lappend node_old $nodea
	}
	eval *createmark nodes 1 $node_old
	*rigidlinkupdate $glo(ele_id) $glo(idcog) 1
	hm_redraw
			
	set glo(id_add) [join $node_a "@"]
	*clearmark node 1
}
proc remove_node {} {
	variable gui; variable arr; global glo
	*createmarkpanel node 1
	set node_remove [hm_getmark node 1]
	*clearmark node 1
	*createmark nodes 1 "by elem id" $glo(ele_id)
	set node_old [hm_getmark nodes 1]
	*clearmark node 1
	set node_rm []
	foreach noder $node_remove {
		set pos [lsearch -all $node_old $noder]
		if {$pos > -1} {
			set node_old [lreplace $node_old $pos $pos]
			set x [hm_getvalue node id=$noder dataname=x]
			set y [hm_getvalue node id=$noder dataname=y]
			set z [hm_getvalue node id=$noder dataname=z]
			lappend node_rm "$x,$y,$z"
		}
	}
	set glo(id_remove) [join $node_rm "@"]
	
	eval *createmark nodes 1 $node_old
	*rigidlinkupdate $glo(ele_id) $glo(idcog) 1
	hm_redraw
}


proc pick_node {} {
	variable gui; variable arr; global glo;global selected_option;
	*createmark nodes 1 $glo(idcog) 
	set node_check [hm_getmark nodes 1]
	if {! [Null node_check]} { 
		tk_messageBox -message "NODE ID already exist"
		set glo(idcog) ""
		return 1
	}
	*createmarkpanel node 1
	set nodes [hm_getmark node 1]	
	*clearmark nodes 1
	set node_p []
	foreach nodep $nodes {
		set x [hm_getvalue node id=$nodep dataname=x]
		set y [hm_getvalue node id=$nodep dataname=y]
		set z [hm_getvalue node id=$nodep dataname=z]
		lappend node_p "$x,$y,$z"
	}
	set glo(id_node) [join $node_p "/"]
	
	if {$selected_option == "QUARE"} { 
		Quare_RBE2_func $nodes
	}
	if {$selected_option == "ROUND3" || $selected_option == "ROUND2"} {
		round_Rbe2_func $nodes
	}
}


proc round_Rbe2_func {nodes} {
	variable gui; global glo; global selected_option;global node_id; global idcog ; global current_tab;
	set node1 [lindex $nodes 0]
	set node2 [lindex $nodes 1]
	set node3 [lindex $nodes 2]
	if {$selected_option == "ROUND3"} {
		*createcenternode $node1 $node2 $node3
	}
	if {$selected_option == "ROUND2"} {
		*createnodesbetweennodes $node1 $node2 1
		
	}
	set node_cog [hm_latestentityid nodes]
	set distan [hm_getdistance nodes $node_cog $node1 0]
	set r [lindex $distan 0]

	*createmark nodes 1 $node1
	*systemcreate 1 0 $node_cog "x-axis" $node2 "xy plane    " $node3
	set sys [hm_latestentityid system]
	set com [split $glo(pids) ","]
	eval *createmark nodes 1 "by comp id" $com
	set node_comp [hm_getmark nodes 1] 
	set list_node_ok []
	foreach node $node_comp {
		set dis [hm_getdistance nodes $node_cog $node $sys]
		if {abs([lindex $dis 3]) < 1 && [lindex $dis 0] < [expr $r+8] && [lindex $dis 0] > [expr $r-12] } {
				lappend list_node_ok $node
		} 
	}
	set node_del []
	set l [llength $list_node_ok]
	for {set i 0} {$i < [expr $l -1]} {incr i} {
		set nodea [lindex $list_node_ok $i]
		set disa [hm_getdistance nodes $node_cog $nodea 0]
		for {set j 0} {$j < $l} {incr j} {
			set nodeb [lindex $list_node_ok $j]
			set disb [hm_getdistance nodes $node_cog $nodeb 0]
			set angel [hm_getangle nodes $nodea $node_cog $nodeb]
			if {$angel < 3 && $disa < $disb} {
				lappend node_del $nodea
			}
			if {$angel < 3 && $disa > $disb} {
				lappend node_del $nodeb
			}
		}
	}
	foreach item $node_del {
		set index [lsearch $list_node_ok $item]
		if {$index != -1} {
			set list_node_ok [lreplace $list_node_ok $index $index]
		}
	} 
	*createmark system 1 $sys
	*deletemark system 1
	*createmark comps 2 "by id only"  $glo(comp_create)
	set comp_name_check [hm_getmark comps 2]
	if {! [Null comp_name_check]} {
		set comp_name [hm_getvalue comp id=$comp_name_check dataname=name]
		*currentcollector components $comp_name
	} else {
		*createentity comps id=$glo(comp_create)
	}
	eval *createmark nodes 2 $list_node_ok
	*rigidlinkinodecalandcreate 2 0 0 123456
	hm_redraw
	eval *createmark components 2 $glo(comp_create)
	*createstringarray 2 "elements_on" "geometry_on"
	*showentitybymark 2 1 2
	*clearmark components 2
	set rbe2 [hm_latestentityid elems]
	set cog [hm_getvalue elems id=$rbe2 dataname=node1]
	*createmark nodes 1 $cog
	*renumbersolverid nodes 1 $glo(idcog) 1 0 0 0 0 0
	
	set x [hm_getvalue node id=$node_cog dataname=x]
	set y [hm_getvalue node id=$node_cog dataname=y]
	set z [hm_getvalue node id=$node_cog dataname=z]
	*setvalue node id=$glo(idcog) x = $x
	*setvalue node id=$glo(idcog) y = $y
	*setvalue node id=$glo(idcog) z = $z

	set glo(ele_id) $rbe2
}

proc Quare_RBE2_func {nodes} {
	variable gui; global glo; global selected_option;global node_id; global idcog ; global current_tab;
	set node_d [lindex $nodes 0]
	set node_c1 [lindex $nodes 1]
	set node_c2 [lindex $nodes 2]
	
	*createmark nodes 1 $node_d
	*systemcreate 1 0 $node_d "x-axis" $node_c1 "xy plane    " $node_c2
	set sys [hm_latestentityid system]
	
	set com [split $glo(pids) ","]
	eval *createmark nodes 1 "by comp id" $com
	set node_comp [hm_getmark nodes 1] 
	set list_node_ok []
	foreach node $node_comp {
		set dis [hm_getdistance nodes $node $node_d $sys]
		if {abs([lindex $dis 3]) < 2 } {
			lappend list_node_ok $node
		} 
	}
	
	*createmark system 1 $sys
	*deletemark system 1
	*createmark comps 2 "by id only" $glo(comp_create)
	set comp_name_check [hm_getmark comps 2]
	if {! [Null comp_name_check]} {
		set comp_name [hm_getvalue comp id=$comp_name_check dataname=name]
		*currentcollector components $comp_name
	} else {
			*createentity comps id=$glo(comp_create)
	}
	
	eval *createmark nodes 2 $list_node_ok
	*rigidlinkinodecalandcreate 2 0 0 123456
	hm_redraw
	eval *createmark components 2 $glo(comp_create)
	*createstringarray 2 "elements_on" "geometry_on"
	*showentitybymark 2 1 2
	*clearmark components 2

	set rbe2 [hm_latestentityid elems]
	set cog [hm_getvalue elems id=$rbe2 dataname=node1]
	*createmark nodes 1 $cog
	*renumbersolverid nodes 1 $glo(idcog) 1 0 0 0 0 0
	
	set rbe2 [hm_latestentityid elems]
	set glo(ele_id) $rbe2
}
proc table1_func_renumbernode {} {
	variable gui; global glo; global selected_option;global node_id; global idcog ; global current_tab;
	set filepc $glo(path_file)
	set id $glo(id)
	*createmark nodes 1 $id 
	set node_check [hm_getmark nodes 1]
	if {! [Null node_check]} { 
		tk_messageBox -message "NODE ID already exist"
		set glo(id) ""
		return 1
	} else {
		*createmarkpanel nodes 1
		set nodes [hm_getmark nodes 1]
		if {[llength $nodes] > 1} {
			tk_messageBox -message "PICK 1 NODE !!"
			*clearmark nodes 1
			return 1
		}
		set node [lindex $nodes 0]
		set x [hm_getvalue node id=$node dataname=x]
		set y [hm_getvalue node id=$node dataname=y]
		set z [hm_getvalue node id=$node dataname=z]
		set data "tab1/$id/$x,$y,$z"
		set file_data "$filepc"
		set writefile1 [open $file_data a]
		puts $writefile1 $data
		close $writefile1
		*createmark nodes 1 $id
		set node_check [hm_getmark nodes 1]
		*createmark nodes 1 $node
		*renumbersolverid nodes 1 $id 1 0 0 0 0 0
		*clearmark nodes 1
		set glo(id) ""
	}
}

main_GUI
