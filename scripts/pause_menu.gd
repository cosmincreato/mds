extends Control

func _on_ResumeButton_pressed():
	
	# nunteleg de ce nu e apelata functia cand dau click
	# pe butonu de resume
	print("Resume pressed")
	get_tree().paused = false

	queue_free()
