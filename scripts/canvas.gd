class_name Canvas extends Control

signal ally_spawned(mouse_x : float, mouse_y : float, type : int)

var texture_rect : TextureRect = get_node_or_null("TextureRect")
var sprite_texture = null
var is_selected: bool = false

### Public

func draw_sprite(texture) -> void:
	sprite_texture = texture
	is_selected = true
	queue_redraw()
	
func remove_sprite() -> void:
	sprite_texture = null
	is_selected = false
	queue_redraw()

### Private

#TODO Repara pozitionarea ciudata a texturii.
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left_mouse") and is_selected:
		var mouse_position = get_local_mouse_position()
		mouse_position.x -= sprite_texture.get_width()/128
		mouse_position.y -= sprite_texture.get_height()/128
		ally_spawned.emit(mouse_position.x, mouse_position.y, 1)

# Desenam pe canvas textura unitatii pe care dorim sa o plasam
func _draw() -> void:
	if sprite_texture:
		var mouse_position = get_global_mouse_position()
		mouse_position.x -= sprite_texture.get_width()/2
		mouse_position.y -= sprite_texture.get_height()/2
		draw_texture(sprite_texture, mouse_position)
		
func _process(_delta: float) -> void:
	if is_selected:
		queue_redraw()
