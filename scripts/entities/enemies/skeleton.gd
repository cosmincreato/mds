class_name Skeleton extends Enemy

func _ready() -> void:
	# Apelam metoda din superclasa
	super()
	print("Skeleton spawned")

func _on_health_component_damage_taken(new_health: int, _amount: int) -> void:
	super(new_health, _amount)

func _on_health_component_died() -> void:
	super()
