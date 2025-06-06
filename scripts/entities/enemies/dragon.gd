class_name Dragon extends Enemy

func _ready() -> void:
	super._ready()
	print("Dragon spawned", get_groups())
