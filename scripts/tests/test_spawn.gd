extends GutTest

func test_spawn_canvas():
	var main_scene = load("res://scenes/main_scene.tscn")
	var ms : MainScene = main_scene.instantiate()
	add_child(ms)
	
	var ev := InputEventAction.new()
	ev.action = "1"
	ev.pressed = true
	
	ms._input(ev)
	
	var canvas := ms.get_node("AllySpawnCanvas")
	assert_true(canvas.visible, "Spawn should be visible after key '1' is pressed")


func test_spawn_ally():
	var main_scene = load("res://scenes/main_scene.tscn")
	var ms : MainScene = main_scene.instantiate()
	add_child(ms)
	
	var ev := InputEventAction.new()
	ev.action = "1"
	ev.pressed = true
	
	ms._input(ev)
	
	var ev2 := InputEventAction.new()
	ev2.action = "left_mouse"
	ev2.pressed = true
	
	if ms.placing_ally:
		ms._input(ev2)
		
	
