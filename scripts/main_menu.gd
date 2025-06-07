extends Control

# Calea către scena principală a jocului
@export var main_scene_path := "res://scenes/main_scene.tscn"

func _on_PlayButton_pressed():
	print("play button pressed")
	
	# Încarcă scena jocului și o adaugă pe ecran
	var main_scene = load(main_scene_path).instantiate()
	get_tree().root.add_child(main_scene)
	

	queue_free()

func _on_ExitButton_pressed():
	print("exit button pressed")
	
	get_tree().quit()
