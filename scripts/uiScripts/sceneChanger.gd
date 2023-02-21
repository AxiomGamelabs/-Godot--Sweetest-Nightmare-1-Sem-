extends Node

export var maxLoadTime = 10000


func goToFatScene(path, currentScene):
	
	var loader = ResourceLoader.load_interactive(path)
	
	if loader == null:
		print("Resource loader unable to load the resource at path")
		return
	
	var loadingScreen = load("res://scenes/uiScenes/loadingScreen.tscn").instance()
	get_tree().get_root().call_deferred('add_child',loadingScreen)
	
#	var t = OS.get_ticks_msec()
	
	while true: #while OS.get_ticks_msec() - t < maxLoadTime:
		var err = loader.poll()
		
		if err == ERR_FILE_EOF:
			
			#delete all nodes in the "levels" group. (i.e. The ones that have the "levels" tag)
			for level in get_tree().get_nodes_in_group("levels"):
				level.queue_free()
			
			var resource = loader.get_resource()
			get_tree().get_root().call_deferred('add_child', resource.instance())

			currentScene.queue_free()
			loadingScreen.queue_free() #after the "fat" scene has been loaded, delete the loadingScreen

			if(get_tree().get_root().get_node("mainMenu")): #falls der main menu noch als child from root node existiert (wenn wir die level1 Szene aus dem mainMenu laden)
				get_tree().get_root().get_node("mainMenu").queue_free() #after the "fat" level1 scene has been loaded, delete the mainMenu

#			if(get_tree().get_root().get_node("level1")): #falls der level1 noch als child from root node existiert (wenn wir die level1 Szene aus dem pause- oder defeat-/win- Menus laden)
#				get_tree().get_root().get_node("level1").queue_free() #after the "fat" level1 scene has been loaded, delete the old level1 Scene

			break
			
		if err == OK: #still loading
			var progress = float(loader.get_stage())/loader.get_stage_count()
			loadingScreen.get_node("loadingScreen/progressBar").value = progress * 100
#			print(progress)
#		else:
#			print("error while loading file")
#			break
		yield(get_tree(),"idle_frame")
