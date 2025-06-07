class_name AllySpawnCanvas extends Control

signal ally_spawned(mouse_x : float, mouse_y : float)

@onready var texture_rect : TextureRect = get_node_or_null("TextureRect")
@onready var cost_label : RichTextLabel = get_node_or_null("CostLabel")

var TEXTURE_RECT_SCALE_FACTOR = 0.8 
### Public

func add_canvas_items(ally_texture : Texture2D, ally_cost : int) -> void:
	if texture_rect:
		texture_rect.texture = ally_texture
		texture_rect.modulate = Color.GRAY
		texture_rect.modulate.a = 0.6
		texture_rect.scale = Vector2(TEXTURE_RECT_SCALE_FACTOR, TEXTURE_RECT_SCALE_FACTOR)
	
	if cost_label:
		cost_label.update(ally_cost)
		
	visible = true
	
func remove_canvas_items() -> void:
	if texture_rect:
		texture_rect.texture = null
	if cost_label:
		cost_label.text = ""
	visible = false

### Private

func _ready() -> void:
	visible = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left_mouse") and visible:
		var mouse_position = get_local_mouse_position()
		ally_spawned.emit(mouse_position.x, mouse_position.y)

# Facem ca textura din TextureRect sa urmareasca pozitia mouse-ului
func _process(_delta: float) -> void:
	if texture_rect and visible:
		var mouse_position = get_global_mouse_position()
		mouse_position.x -= texture_rect.texture.get_width()
		mouse_position.y -= texture_rect.texture.get_height()
		texture_rect.position = mouse_position
