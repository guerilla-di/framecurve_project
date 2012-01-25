/*
framecurve importer
v0.5, UNTESTED , TRANSFORMS ONLY!
Koen Hofmeester 2011

Framecurve scripts are subject to MIT license
http://framecurve.org/scripts/#license

TODO:
-TRANSFORMS ONLY!, need to include fov and other shiz 
-Bake after warp? Interpolation issues? Moblur??
-Multiple executes destroy dialog fix
-Better way to warp?
-Cleanup code
*/

rollout roGDTimeWarp "GD_TIMEWARP" width:250 height:300
(
	groupBox grpMain "GUERILLADI timeWarp" pos:[4,3] width:242 height:293
		groupBox grpFile "Input" pos:[8,32] width:232 height:87
			editText edtFile pos:[16,56] width:216 height:16
			button btnFile "browse" pos:[32,88] width:88 height:16
		
		groupBox grpCam "Camera" pos:[9,128] width:232 height:87
			editText edtCam pos:[17,152] width:216 height:16
			button btnCam "get" pos:[33,184] width:88 height:16
	
	button btnWarp "WARP!" pos:[32,240] width:184 height:32

	
	/* BROWSE FOR FILE*/
	on btnFile pressed do
	(
			loadpath = getOpenFileName caption:"Open A Test File:" types:"timewarp(*.txt)"
			if loadpath != undefined do
			(
				edtFile.text = loadpath
			)	
	)
	
	on btnCam pressed do
	(
		if selection.count != 0 do 
		(
			print selection.count	
			cam = selection[1].name
			/* WTF! ARRAYS START AT ONE??? */
			edtCam.text = cam
		)
			
		
	)
	
	on btnWarp pressed do
	(
		/* START THE MAGIC */
		
		warpfile = edtFile.text
		warpcam  = edtCam.text
		warpfileread = openfile warpfile mode:"rt"
		
		/* ERROR WHEN FILE DOES NOT EXISTS */
		if warpfileread == undefined do (print  "Timewarp File Not Found!"; errorState = True)
		
		/*NEED TO GET REALNAME OF OBJECT */
		warpcamnode = getnodebyname warpcam
		if warpcamnode == undefined do (print "Object Does Not Exists"; errorState = True)
		print warpcamnode

		/*SOME CLONING*/
		clonecameras = maxOps.CloneNodes warpcamnode cloneType:#copy newNodes:&duplcam
		newwarpcam = duplcam[1]
		
		/*TMP TRANSFORM STORE */
		tmpstore = Point()
		with redraw on 
		with animate on 
			
		
		local lastDestFrame
		local lastValue
		 
		while not eof warpfileread do
		(
			inputline = readline warpfileread
			tokenize = filterString inputline "\t, "
			
			/* BAKING THE CAMERA */
			destFrameNumber = tokenize[1] as float
			sourceFrameNumber = tokenize[2] as float
			
			sliderTime = destFrameNumber
			
			/*COPY VALS BACK*/
			with animate on at time newtime tmpstore.transform = at time oldtime newwarpcam.transform
		)

				

		newwarpcam.transform.controller =  tmpstore.transform.controller 
		newwarpcam.name = warpcam + "_TW"
		delete tmpstore
		try (destroyDialog roGDTimeWarp)catch()
		
	)
			

)


try destroyDialog roGDTimeWarp catch() --does not work!!, need fixing
dialog = roGDTimeWarp 
createDialog dialog width:250 height:300 model:true

	

