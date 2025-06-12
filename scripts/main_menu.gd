extends Control

@export var main_scene_path := "res://scenes/main_scene.tscn"

func _on_PlayButton_pressed():
	var main_scene = load(main_scene_path).instantiate()
	get_tree().root.add_child(main_scene)

	queue_free()

func _on_ExitButton_pressed():
	get_tree().quit()
