# PYTHON script
import os
import ansa
import unicodedata
from ansa import*
import math
from itertools import chain

##---------------------------------------------------Main-----------------------------------------------------------------------
def main():
	## Input path
	base.SetCurrentDeck(constants.NASTRAN)
	base.SetANSAdefaultsValues({"vip_wspot_key":"GRID"})
	ExPath = "_EXCEL-LINK_"
	
	## Read input
	InDict = ReadExcelInput(ExPath)

	ListCut = InDict["ListCut"]
	for i in range(0,len(ListCut)):
		CutTimes = ListCut[i]
		if CutTimes[0]["Name"]!= "" and CutTimes[0]["Name"]!= None:
			InFolder = os.fsdecode(os.path.join(os.fsencode(InDict["InputPath"]),os.fsencode(CutTimes[0]["Name"])))
			if os.path.exists(InFolder)==False:
				print("Not found: "+InFolder)
				flag = 0
			else:
				MasterPath,MasterName,ListVip = ReadFolderInput(InFolder)
				## Import
				ListVipConns = ImportInput(MasterPath,ListVip)
				flag = 1
		if flag == 1:
			## Apply spot connection
			for Spot in base.CollectEntitiesI(1,None,"__CONNECTIONS__",recursive=True,filter_visible=False):
				base.SetEntityCardValues(1,Spot,{"FE Rep Type":"RBE3-HEXA-RBE3"})
			Spots = base.CollectEntities(1,None,"__CONNECTIONS__",recursive=True,filter_visible=False)
			connections.ReApplyConnections(Spots)
			
			## Create spc group
			spcadd = base.CreateEntity(1, "SPCADD")
			
			## Cut module
			for j in range(0,len(CutTimes)):
				if CutTimes[j]["Type"] == "Cross":
					CutPoint1 = [CutTimes[j]["x"],CutTimes[j]["y"],CutTimes[j]["z"]]
					CutSide = CutTimes[j]["CutSide"]
					BasePoint1 = FindCrossCutBasePoint(CutPoint1,CutSide)
				elif CutTimes[j]["Type"] == "Straight":
					CutPoint2 = [CutTimes[j]["x"],CutTimes[j]["y"],CutTimes[j]["z"]]
					CutSide = CutTimes[j]["CutSide"]
					StraightCut(CutPoint2,CutSide,spcadd)
					RemoveSpotStraight(CutPoint2,CutSide)
			for j in range(0,len(CutTimes)):
				if CutTimes[j]["Type"] == "Cross":
					CutSide = CutTimes[j]["CutSide"]
					base.All()
					CrossCut (BasePoint1,CutPoint1,CutSide,spcadd)
					RemoveSpotCross(CutPoint1,CutSide)
					
			## Output and ReImport if next name
			base.Compress("")
			ExportOutput(InFolder,MasterName,ListVip,ListVipConns)
	session.Quit()
			
##------------------------------------------------------------------------------------------------------------------------------


def ExportOutput(OutputPath,MasterName,ListVip,ListVipConns):
	MasterFileName, file_extension = os.path.splitext(MasterName)
	FolderName = os.path.basename(OutputPath)
	for i in range(0,len(ListVip)):
		# Del old vip file
		OldVipFile = os.fsdecode(os.path.join(os.fsencode(OutputPath),os.fsencode(ListVip[i])))
		os.remove(OldVipFile)
		
		# Output new vip file
		filename = os.path.basename(ListVip[i])
		name_output = filename.replace("BI" ,"CB-" + FolderName.split("_")[1])
		OutputSpotPath = OutputPath + "/"+ name_output
		Conns = [x for x in ListVipConns[i] if x._id is not None]
		if Conns!=[]:
			connections.OutputConnections(Conns,"VIP",OutputSpotPath)
	
	# Delete old master file
	ModelPath = os.fsdecode(os.path.join(os.fsencode(OutputPath),os.fsencode(MasterName)))
	os.remove(ModelPath)
	
	# Output new master file	
	Conns = base.CollectEntities(1,None,"__CONNECTIONS__",recursive=True,filter_visible=False)
	base.DeleteEntity(Conns,True,True)
	name_output = MasterName.replace("BI_Master" ,"CB-" + FolderName.split("_")[1])
	OutputModelPath = os.fsdecode(os.path.join(os.fsencode(OutputPath),os.fsencode(name_output)))
	plane_cut = base.CollectEntities(1, None, "CUTTING PLANE")
	base.DeleteEntity (plane_cut,True,True)
	base.SetEntityVisibilityValues(constants.NASTRAN, {"all": "on"})
	base.All()
	re = base.OutputNastran(OutputModelPath,"all")


def RemoveSpotStraight(CutPoint,CutWay):
	CutPoint = list(map(float,CutPoint))
	Spots = base.CollectEntities(1,None,"SpotweldPoint_Type",filter_visible=False)
	for spot in Spots:
		spot_val = base.GetEntityCardValues(1, spot, {"X","Y","Z"})
		if CutWay.lower() == "x-" and spot_val["X"]>CutPoint[0]:
			base.DeleteEntity(spot,True,True)
		elif CutWay.lower() == "x" and spot_val["X"]<CutPoint[0]:
			base.DeleteEntity(spot,True,True)
		elif CutWay.lower() == "y-" and spot_val["Y"]>CutPoint[1]:
			base.DeleteEntity(spot,True,True)
		elif CutWay.lower() == "y" and spot_val["Y"]<CutPoint[1]:
			base.DeleteEntity(spot,True,True)
		elif CutWay.lower() == "z-" and spot_val["Z"]>CutPoint[2]:
			base.DeleteEntity(spot,True,True)
		elif CutWay.lower() == "z" and spot_val["Z"]<CutPoint[2]:
			base.DeleteEntity(spot,True,True)


def RemoveSpotCross(CutPoint,CutWay):
	CutPoint = list(map(float,CutPoint))
	Spots = base.CollectEntities(1,None,"SpotweldPoint_Type",filter_visible=False)
	for spot in Spots:
		spot_val = base.GetEntityCardValues(1, spot, {"X","Y","Z"})
		if spot_val["Z"]>(CutPoint[2]-300):
			if CutWay.lower() == "x-" and spot_val["X"]>(CutPoint[0]-10):
				base.DeleteEntity(spot,True,True)
			elif CutWay.lower() == "x" and spot_val["X"]<(CutPoint[0]+10):
				base.DeleteEntity(spot,True,True)
			elif CutWay.lower() == "y-" and spot_val["Y"]>(CutPoint[1]-10):
				base.DeleteEntity(spot,True,True)
			elif CutWay.lower() == "y" and spot_val["Y"]<(CutPoint[1]+10):
				base.DeleteEntity(spot,True,True)


def ReadFolderInput(InFolder):
	for root, dirs, files in os.walk(InFolder):
		ParentPath = root
		ListFile = files
		break
	ListVip = []
	for file in ListFile:
		filename, file_extension = os.path.splitext(file)
		if file_extension == ".gz" and ".nas" in filename:
			filename1, file_extension1 = os.path.splitext(filename)
			MasterName = filename1
			MasterPath = os.fsdecode(os.path.join(os.fsencode(root), os.fsencode(file)))
		elif file_extension == ".nas":
			MasterName = file
			MasterPath = os.fsdecode(os.path.join(os.fsencode(root),os.fsencode(file)))
		elif file_extension == ".vip":
			VipPath = os.fsdecode(os.path.join(os.fsencode(root), os.fsencode(file)))
			ListVip.append(VipPath)
		elif file_extension == ".gz" and ".vip" in filename:
			VipPath = os.fsdecode(os.path.join(os.fsencode(root), os.fsencode(file)))
			ListVip.append(VipPath)
	return MasterPath,MasterName,ListVip
	
	
def ImportInput(MasterPath,ListVip):			
	session.New("discard")
	base.InputNastran(MasterPath)
	ListVipConns = []
	for file in ListVip:
		connections.ReadConnections("VIP",file)
		Conns0 = base.CollectEntities(1,None,"__CONNECTIONS__")
		Conns0 = [x for x in Conns0]
		Conns1 = [x for x in Conns0 if x not in (list(chain(*ListVipConns)))]
		ListVipConns.append(Conns1)
	return ListVipConns


def ReadExcelInput(ExPath):
	ExRef = utils.XlsxOpen(ExPath)
	InDict = {}
	folder_inputs = utils.XlsxGetCellValue(ExRef, "Input", 17, 3)
	InDict["InputPath"] = unicodedata.normalize('NFKC', folder_inputs)

	ListCut = []
	CutTimes = []
	for i in range(7,100):
		DictCut={}
		DictCut["Name"] = utils.XlsxGetCellValue(ExRef, "MASTER", i, 25)
		DictCut["Type"] = utils.XlsxGetCellValue(ExRef, "MASTER", i, 26)
		DictCut["CutSide"] = utils.XlsxGetCellValue(ExRef, "MASTER", i, 27)
		DictCut["x"] = utils.XlsxGetCellValue(ExRef, "MASTER", i, 28)
		DictCut["y"] = utils.XlsxGetCellValue(ExRef, "MASTER", i, 29)
		DictCut["z"] = utils.XlsxGetCellValue(ExRef, "MASTER", i, 30)
		if i !=7 and DictCut["Name"] != "" and DictCut["Name"] != None:
			ListCut.append(CutTimes)
			CutTimes = []
		if DictCut["Type"] == "" or DictCut["Type"] == None or \
		DictCut["CutSide"] == "" or DictCut["CutSide"] == None or \
		DictCut["x"] == "" or DictCut["x"] == None or \
		DictCut["y"] == "" or DictCut["y"] == None or \
		DictCut["z"] == "" or DictCut["z"] == None :
			ListCut.append(CutTimes)
			break
		CutTimes.append(DictCut)
	InDict["ListCut"] = ListCut
	utils.XlsxClose(ExRef)
	
	return InDict


def StraightCut (node1_coord,CutSide,spcadd):
	node1_x = float(node1_coord[0])
	node1_y = float(node1_coord[1])
	node1_z = float(node1_coord[2])
	# Create a Cutting Plane
	if "x-" in CutSide.lower():
		pl1 = base.CreateEntity(1, "CUTTING PLANE",
								('Clip', "YES","Cut All Models","YES","CUT","ALL","OF","ALL",
								'oX', node1_x, 'oY', node1_y, 'oZ', node1_z,
								'xX', 0, 'xY', 1, 'xZ', 0,
								'zX', -1, 'zY', 0, 'zZ', 0))	
		pl2 = base.CreateEntity(1, "CUTTING PLANE",
								('Clip', "YES","Cut All Models","YES","CUT","ALL","OF","ALL",
								'oX', node1_x-30, 'oY', node1_y, 'oZ', node1_z,
								'xX', 0, 'xY', 1, 'xZ', 0,
								'zX', -1, 'zY', 0, 'zZ', 0))
		pl3 = base.CreateEntity(1, "CUTTING PLANE",
								('Clip', "YES","Cut All Models","YES","CUT","ALL","OF","ALL",
								'oX', node1_x-15, 'oY', node1_y, 'oZ', node1_z,
								'xX', 0, 'xY', 1, 'xZ', 0,
								'zX', -1, 'zY', 0, 'zZ', 0))
	elif "x" in CutSide.lower():
		pl1 = base.CreateEntity(1, "CUTTING PLANE",
								('Clip', "YES","Cut All Models","YES","CUT","ALL","OF","ALL",
								'oX', node1_x, 'oY', node1_y, 'oZ', node1_z,
								'xX', 0, 'xY', 1, 'xZ', 0,
								'zX', 1, 'zY', 0, 'zZ', 0))
		pl2 = base.CreateEntity(1, "CUTTING PLANE",
								('Clip', "YES","Cut All Models","YES","CUT","ALL","OF","ALL",
								'oX', node1_x+30, 'oY', node1_y, 'oZ', node1_z,
								'xX', 0, 'xY', 1, 'xZ', 0,
								'zX', 1, 'zY', 0, 'zZ', 0))
		pl3 = base.CreateEntity(1, "CUTTING PLANE",
								('Clip', "YES","Cut All Models","YES","CUT","ALL","OF","ALL",
								'oX', node1_x+15, 'oY', node1_y, 'oZ', node1_z,
								'xX', 0, 'xY', 1, 'xZ', 0,
								'zX', 1, 'zY', 0, 'zZ', 0))
	elif "y-" in CutSide.lower():
		pl1 = base.CreateEntity(1, "CUTTING PLANE",
								('Clip', "YES","Cut All Models","YES","CUT","ALL","OF","ALL",
								'oX', node1_x, 'oY', node1_y, 'oZ', node1_z,
								'xX', 1, 'xY', 0, 'xZ', 0,
								'zX', 0, 'zY', -1, 'zZ', 0))
		pl2 = base.CreateEntity(1, "CUTTING PLANE",
								('Clip', "YES","Cut All Models","YES","CUT","ALL","OF","ALL",
								'oX', node1_x, 'oY', node1_y-30, 'oZ', node1_z,
								'xX', 1, 'xY', 0, 'xZ', 0,
								'zX', 0, 'zY', -1, 'zZ', 0))
		pl3 = base.CreateEntity(1, "CUTTING PLANE",
								('Clip', "YES","Cut All Models","YES","CUT","ALL","OF","ALL",
								'oX', node1_x, 'oY', node1_y-15, 'oZ', node1_z,
								'xX', 1, 'xY', 0, 'xZ', 0,
								'zX', 0, 'zY', -1, 'zZ', 0))
	elif "y" in CutSide.lower():	
		pl1 = base.CreateEntity(1, "CUTTING PLANE",
								('Clip', "YES","Cut All Models","YES","CUT","ALL","OF","ALL",
								'oX', node1_x, 'oY', node1_y, 'oZ', node1_z,
								'xX', 1, 'xY', 0, 'xZ', 0,
								'zX', 0, 'zY', 1, 'zZ', 0))
		pl2 = base.CreateEntity(1, "CUTTING PLANE",
								('Clip', "YES","Cut All Models","YES","CUT","ALL","OF","ALL",
								'oX', node1_x, 'oY', node1_y+30, 'oZ', node1_z,
								'xX', 1, 'xY', 0, 'xZ', 0,
								'zX', 0, 'zY', 1, 'zZ', 0))
		pl3 = base.CreateEntity(1, "CUTTING PLANE",
								('Clip', "YES","Cut All Models","YES","CUT","ALL","OF","ALL",
								'oX', node1_x, 'oY', node1_y+15, 'oZ', node1_z,
								'xX', 1, 'xY', 0, 'xZ', 0,
								'zX', 0, 'zY', 1, 'zZ', 0))
	elif "z-" in CutSide.lower():
		pl1 = base.CreateEntity(1, "CUTTING PLANE",
								('Clip', "YES","Cut All Models","YES","CUT","ALL","OF","ALL",
								'oX', node1_x, 'oY', node1_y, 'oZ', node1_z,
								'xX', 1, 'xY', 0, 'xZ', 0,
								'zX', 0, 'zY', 0, 'zZ', -1))
		pl2 = base.CreateEntity(1, "CUTTING PLANE",
								('Clip', "YES","Cut All Models","YES","CUT","ALL","OF","ALL",
								'oX', node1_x, 'oY', node1_y, 'oZ', node1_z-30,
								'xX', 1, 'xY', 0, 'xZ', 0,
								'zX', 0, 'zY', 0, 'zZ', -1))
		pl3 = base.CreateEntity(1, "CUTTING PLANE",
								('Clip', "YES","Cut All Models","YES","CUT","ALL","OF","ALL",
								'oX', node1_x, 'oY', node1_y, 'oZ', node1_z-15,
								'xX', 1, 'xY', 0, 'xZ', 0,
								'zX', 0, 'zY', 0, 'zZ', -1))
	elif  "z" in  CutSide.lower():	
		pl1 = base.CreateEntity(1, "CUTTING PLANE",
								('Clip', "YES","Cut All Models","YES","CUT","ALL","OF","ALL",
								'oX', node1_x, 'oY', node1_y, 'oZ', node1_z,
								'xX', 1, 'xY', 0, 'xZ', 0,
								'zX', 0, 'zY', 0, 'zZ', 1))
		pl2 = base.CreateEntity(1, "CUTTING PLANE",
								('Clip', "YES","Cut All Models","YES","CUT","ALL","OF","ALL",
								'oX', node1_x, 'oY', node1_y, 'oZ', node1_z+30,
								'xX', 1, 'xY', 0, 'xZ', 0,
								'zX', 0, 'zY', 0, 'zZ', 1))
		pl3 = base.CreateEntity(1, "CUTTING PLANE",
								('Clip', "YES","Cut All Models","YES","CUT","ALL","OF","ALL",
								'oX', node1_x, 'oY', node1_y, 'oZ', node1_z+15,
								'xX', 1, 'xY', 0, 'xZ', 0,
								'zX', 0, 'zY', 0, 'zZ', 1))
	
	# Create a Model Cut
	md_cut = base.CreateEntity(1, "MODEL CUT")
	base.SetEntityCardValues(1,md_cut,{"Removed entities":"Delete","Unconnected parts":"Remove all"})
	# Put Cutting plane in Model Cut
	base.ModelCutAddPlane(md_cut, pl1)
	# Perform cut. Model Cut will use the Cutting Plane added to it in order to cut the model
	base.ModelCutApply(md_cut)
	## Create set for set up restraint
	set1 = base.CreateEntity(1, "SET")
	md_cut2 = base.CreateEntity(1, "MODEL CUT")
	base.SetEntityCardValues(1,md_cut2,{"Unconnected parts":"Remove all","Removed entities":"Put in set","Set for removed":set1._id})
	base.ModelCutAddPlane(md_cut2, pl2)
	base.ModelCutApply(md_cut2)
	## Create set for remove spot within 15mm form cut plane
	set2 = base.CreateEntity(1, "SET")
	md_cut3 = base.CreateEntity(1, "MODEL CUT")
	base.SetEntityCardValues(1,md_cut3,{"Unconnected parts":"Remove all","Removed entities":"Put in set","Set for removed":set2._id})
	base.ModelCutAddPlane(md_cut3, pl3)
	base.ModelCutApply(md_cut3)
	base.Or(set2)
	Spots = base.CollectEntities(1,None,"__CONNECTIONS__",filter_visible = True)
	base.DeleteEntity(Spots,True,True)
	## Setup Restraint
	SetupRestraint(set1,spcadd)
	## Delete sets
	base.DeleteEntity(set1,True,True)
	base.DeleteEntity(set2,True,True)
	
def SetupRestraint(set,spcadd):
	base.Or(set)
	base.Near(30,custom_entities=set)
	Elems1d =[]
	for Elem in base.CollectEntitiesI(1,None,"__ELEMENTS__",filter_visible = True):
		ElemType = base.GetEntityType(1, Elem)
		if ElemType == "CBEAM":
			Elems1d.append(Elem)
		elif ElemType == "PLOTEL":
			Elems1d.append(Elem)
		elif ElemType == "RBAR":
			Elems1d.append(Elem)
		elif ElemType == "RBE2":
			Elems1d.append(Elem)
		elif ElemType == "RBE3":
			Elems1d.append(Elem)
		elif ElemType == "CELAS":
			Elems1d.append(Elem)
		elif ElemType == "SOLID":
			Elems1d.append(Elem)
	
	Node1d = base.CollectEntities(1,Elems1d,"GRID",filter_visible = False,recursive = True)
	Nodes = base.CollectEntities(1,set,"GRID",filter_visible = False,recursive = True)
	NodeSPC = [x for x in Nodes if x not in Node1d]
	for node in NodeSPC:
		base.CreateEntity(1, "SPC",{"SID":spcadd._id,"by":"node","G":node._id,"C":"123456"})
		
	
def CrossCut (node1_coord,node2_coord,CutSide,spcadd):
	node1_x = float(node1_coord[0])
	node1_y = float(node1_coord[1])
	node1_z = float(node1_coord[2])
	node2_x = float(node2_coord[0])
	node2_y = float(node2_coord[1])
	node2_z = float(node2_coord[2])
	pl = base.CreateEntity(1, "CUTTING PLANE",
							('Clip', "YES","Cut All Models","YES","CUT","ALL","OF","ALL",
							'oX', node2_x, 'oY', node2_x, 'oZ', node2_z-100,
							'xX', 1, 'xY', 0, 'xZ', 0,
							'zX', 0, 'zY', 0, 'zZ', -1))
							
	set1 = base.CreateEntity(1, "SET")
	# Create a Model Cut
	md_cut = base.CreateEntity(1, "MODEL CUT")
	base.SetEntityCardValues(1,md_cut,{"Unconnected parts":"Remove all","Removed entities":"Put in set","Set for removed":set1._id})
	# Put Cutting plane in Model Cut
	base.ModelCutAddPlane(md_cut, pl)
	# Perform cut. Model Cut will use the Cutting Plane added to it in order to cut the model
	base.ModelCutApply(md_cut)
	base.Or(set1)
	# Create a Cutting Plane
	if "x-" in CutSide.lower():
		pl1 = base.CreateEntity(1, "CUTTING PLANE",
								('Clip', "NO","Cut All Models","NO",
								"CUT","VISIBLE","OF","SET","SET",set1._id,
								'oX', node2_x, 'oY', node2_y, 'oZ', node2_z,
								'xX', 0, 'xY', 1, 'xZ', 0,
								'zX', (node1_x-node2_x), 'zY', 0, 'zZ', (node1_z-node2_z)))
		pl2 = base.CreateEntity(1, "CUTTING PLANE",
								('Clip', "NO","Cut All Models","NO",
								"CUT","VISIBLE","OF","SET","SET",set1._id,
								'oX', node2_x-30, 'oY', node2_y-30, 'oZ', node2_z-30,
								'xX', 0, 'xY', 1, 'xZ', 0,
								'zX', (node1_x-node2_x), 'zY', 0, 'zZ', (node1_z-node2_z)))
		pl3 = base.CreateEntity(1, "CUTTING PLANE",
								('Clip', "NO","Cut All Models","NO",
								"CUT","VISIBLE","OF","SET","SET",set1._id,
								'oX', node2_x-15, 'oY', node2_y-15, 'oZ', node2_z-15,
								'xX', 0, 'xY', 1, 'xZ', 0,
								'zX', (node1_x-node2_x), 'zY', 0, 'zZ', (node1_z-node2_z)))
	elif "x" in CutSide.lower():
		pl1 = base.CreateEntity(1, "CUTTING PLANE",
								('Clip', "NO","Cut All Models","NO",
								"CUT","ALL","OF","SET","SET",set1._id,
								'oX', node2_x, 'oY', node2_y, 'oZ', node2_z,
								'xX', 0, 'xY', 1, 'xZ', 0,
								'zX', (node2_x-node1_x), 'zY', 0, 'zZ', (node2_z-node1_z)))
		pl2 = base.CreateEntity(1, "CUTTING PLANE",
								('Clip', "NO","Cut All Models","NO",
								"CUT","VISIBLE","OF","SET","SET",set1._id,
								'oX', node2_x+30, 'oY', node2_y+30, 'oZ', node2_z+30,
								'xX', 0, 'xY', 1, 'xZ', 0,
								'zX', (node2_x-node1_x), 'zY', 0, 'zZ', (node2_z-node1_z)))
		pl3 = base.CreateEntity(1, "CUTTING PLANE",
								('Clip', "NO","Cut All Models","NO",
								"CUT","VISIBLE","OF","SET","SET",set1._id,
								'oX', node2_x+15, 'oY', node2_y+15, 'oZ', node2_z+15,
								'xX', 0, 'xY', 1, 'xZ', 0,
								'zX', (node2_x-node1_x), 'zY', 0, 'zZ', (node2_z-node1_z)))
	elif "y-" in CutSide.lower():
		pl1 = base.CreateEntity(1, "CUTTING PLANE",
								('Clip', "NO","Cut All Models","NO",
								"CUT","ALL","OF","SET","SET",set1._id,
								'oX', node2_x, 'oY', node2_y, 'oZ', node2_z,
								'xX', 1, 'xY', 0, 'xZ', 0,
								'zX', 0, 'zY', (node1_y-node2_y), 'zZ', (node1_z-node2_z)))
		pl2 = base.CreateEntity(1, "CUTTING PLANE",
								('Clip', "NO","Cut All Models","NO",
								"CUT","ALL","OF","SET","SET",set1._id,
								'oX', node2_x-30, 'oY', node2_y-30, 'oZ', node2_z-30,
								'xX', 1, 'xY', 0, 'xZ', 0,
								'zX', 0, 'zY', (node1_y-node2_y), 'zZ', (node1_z-node2_z)))
		pl3 = base.CreateEntity(1, "CUTTING PLANE",
								('Clip', "NO","Cut All Models","NO",
								"CUT","ALL","OF","SET","SET",set1._id,
								'oX', node2_x-15, 'oY', node2_y-15, 'oZ', node2_z-15,
								'xX', 1, 'xY', 0, 'xZ', 0,
								'zX', 0, 'zY', (node1_y-node2_y), 'zZ', (node1_z-node2_z)))
	elif "y" in CutSide.lower():	
		pl1 = base.CreateEntity(1, "CUTTING PLANE",
								('Clip', "NO","Cut All Models","NO",
								"CUT","ALL","OF","SET","SET",set1._id,
								'oX', node2_x, 'oY', node2_y, 'oZ', node2_z,
								'xX', 1, 'xY', 0, 'xZ', 0,
								'zX', 0, 'zY', (node2_y-node1_y), 'zZ', (node2_z-node1_z)))
		pl2 = base.CreateEntity(1, "CUTTING PLANE",
								('Clip', "NO","Cut All Models","NO",
								"CUT","ALL","OF","SET","SET",set1._id,
								'oX', node2_x+30, 'oY', node2_y+30, 'oZ', node2_z+30,
								'xX', 1, 'xY', 0, 'xZ', 0,
								'zX', 0, 'zY', (node2_y-node1_y), 'zZ', (node2_z-node1_z)))
		pl3 = base.CreateEntity(1, "CUTTING PLANE",
								('Clip', "NO","Cut All Models","NO",
								"CUT","ALL","OF","SET","SET",set1._id,
								'oX', node2_x+15, 'oY', node2_y+15, 'oZ', node2_z+15,
								'xX', 1, 'xY', 0, 'xZ', 0,
								'zX', 0, 'zY', (node2_y-node1_y), 'zZ', (node2_z-node1_z)))
	# Create a Model Cut
	md_cut1 = base.CreateEntity(1, "MODEL CUT")
	base.SetEntityCardValues(1,md_cut1,{"Removed entities":"Delete","Unconnected parts":"Remove all"})
	# Put Cutting plane in Model Cut
	base.ModelCutAddPlane(md_cut1, pl1)
	# Perform cut. Model Cut will use the Cutting Plane added to it in order to cut the model
	base.ModelCutApply(md_cut1)
	## Create set for set up restraint
	set2 = base.CreateEntity(1, "SET")
	md_cut2 = base.CreateEntity(1, "MODEL CUT")
	base.SetEntityCardValues(1,md_cut2,{"Unconnected parts":"Remove all","Removed entities":"Put in set","Set for removed":set2._id})
	base.ModelCutAddPlane(md_cut2, pl2)
	base.ModelCutApply(md_cut2)
	## Create set for remove spot within 15mm form cut plane
	set3 = base.CreateEntity(1, "SET")
	md_cut3 = base.CreateEntity(1, "MODEL CUT")
	base.SetEntityCardValues(1,md_cut3,{"Unconnected parts":"Remove all","Removed entities":"Put in set","Set for removed":set3._id})
	base.ModelCutAddPlane(md_cut3, pl3)
	base.ModelCutApply(md_cut3)
	base.Or(set3)
	Spots = base.CollectEntities(1,None,"__CONNECTIONS__",filter_visible = True)
	base.DeleteEntity(Spots,True,True)
	## Setup Restraint
	SetupRestraint(set2,spcadd)
	## Delete sets
	base.DeleteEntity(set1,True,True)
	base.DeleteEntity(set2,True,True)


def FindCrossCutBasePoint(node1_coord,CutSide):

	node1_coord_x = float(node1_coord[0])
	node1_coord_y = float(node1_coord[1])
	node1_coord_z = float(node1_coord[2])
	node1_coord =[node1_coord_x,node1_coord_y,node1_coord_z]
	# Find node 2 is 150mm away from node 1
	node1 = base.NearestNode(node1_coord, 10)
	node1 = node1[0]
	node1_x = base.GetEntityCardValues(1,node1,["X1"])["X1"]
	node1_y = base.GetEntityCardValues(1,node1,["X2"])["X2"]
	node1_z = base.GetEntityCardValues(1,node1,["X3"])["X3"]
	nearest_shell = base.NearestShell(node1_coord, 10)
	nearest_shell = nearest_shell[0]
	PID = base.GetEntityCardValues(1,nearest_shell,["PID"])["PID"]
	Prop = base.GetEntity(1,"__PROPERTIES__",PID)
	nodes = base.CollectBoundaryNodes(Prop, True)
	list_bounds = nodes.perimeters
	list_base = []
	for list_nodes in list_bounds:
		for node in list_nodes:
			if node._id == node1._id:
				list_base = list_nodes
	min_dist = 100
	for node in list_base:
		if node != node1:
			node_x = base.GetEntityCardValues(1,node,["X1"])["X1"]
			node_y = base.GetEntityCardValues(1,node,["X2"])["X2"]
			msr = base.CreateMeasurement([node1,node], "DISTANCE")
			dist = base.GetEntityCardValues(1,msr,["RESULT"])["RESULT"]
			base.DeleteEntity(msr,True,True)
			if CutSide.lower() == "x-" or CutSide.lower() == "x":
				if dist < min_dist and node_x < node1_x:
					min_dist = dist
					node2 = node
			elif CutSide.lower() == "y-" or CutSide.lower() == "y":
				if dist < min_dist and node_y < node1_y:
					min_dist = dist
					node2 = node
	
	node2_x = base.GetEntityCardValues(1,node2,["X1"])["X1"]
	node2_y = base.GetEntityCardValues(1,node2,["X2"])["X2"]
	node2_z = base.GetEntityCardValues(1,node2,["X3"])["X3"]
	node3 = [node2_x,node2_y,node2_z]
	
	return node3


if __name__ == '__main__':
	main()

