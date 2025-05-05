class_name Skeleton extends Enemy

func _ready() -> void:
	# Apelam metoda din superclasa
	super._ready()
	print("Skeleton spawned")

func _on_hurtbox_body_entered(body: Node2D) -> void:
	print("Hurtbox entered")
	if body.get_parent().is_in_group("allies"):
		attacking = body.get_parent()

func _on_attack_area_body_entered(body: Node2D) -> void:
	print("Area entered")
	if (body.get_parent().is_in_group("allies")):
		seeking = body
