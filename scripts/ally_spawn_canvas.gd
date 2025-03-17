class_name AllySpawnCanvas extends Control

signal ally_spawned(mouse_x : float, mouse_y : float, type : int)

@onready var texture_rect : TextureRect = get_node_or_null("TextureRect")
@onready var cost_label : RichTextLabel = get_node_or_null("CostLabel")

var is_active: bool = false

### Public

func add_canvas_items(ally_texture : Texture2D, ally_cost : int) -> void:
	if texture_rect:
		texture_rect.texture = ally_texture
	if cost_label:
		cost_label.update(ally_cost)
	is_active = true
	
func remove_canvas_items() -> void:
	if texture_rect:
		texture_rect.texture = null
	if cost_label:
		cost_label.text = ""
	is_active = false

### Private

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left_mouse") and is_active:
		var mouse_position = get_local_mouse_position()
		ally_spawned.emit(mouse_position.x, mouse_position.y, 1)

# Facem ca textura din TextureRect sa urmareasca pozitia mouse-ului
func _process(_delta: float) -> void:
	if texture_rect and is_active:
		var mouse_position = get_global_mouse_position()
		mouse_position.x -= texture_rect.texture.get_width()/2
		mouse_position.y -= texture_rect.texture.get_height()/2
		texture_rect.position = mouse_position
