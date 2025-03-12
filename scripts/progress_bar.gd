extends ProgressBar

var parent : Control = null

func _ready() -> void:
	visible = false


func set_dependencies(p: Control):
	self.parent = p
	max_value = parent.max_health

func _on_health_bar_damage_taken(new_health: int, amount: int) -> void:
	visible = true
	value = new_health
