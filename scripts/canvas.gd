extends Node2D

var sprite_texture = null
var parent: Node = null
var is_selected: bool = false

func set_dependencies(p: Node):
	self.parent = p
	parent.draw_sprite.connect(_on_draw_sprite)
	parent.remove_sprite.connect(_on_remove_sprite)

func _on_draw_sprite(texture):
	sprite_texture = texture
	is_selected = true
	queue_redraw()
	
func _on_remove_sprite():
	sprite_texture = null
	is_selected = false
	queue_redraw()

func _draw() -> void:
	if sprite_texture:
		var mouse_position = get_global_mouse_position()
		mouse_position.x -= sprite_texture.get_width()/2
		mouse_position.y -= sprite_texture.get_height()/2
		draw_texture(sprite_texture, mouse_position)
		
func _process(_delta: float) -> void:
	if is_selected:
		queue_redraw()
