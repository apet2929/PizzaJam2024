extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	if has_node("../../Worm") and has_node("../../GameCamera") and has_node("../../Box"):
		var worm = get_node("../../Worm")
		var cam = get_node("../../GameCamera")
		var box = get_node("../../Box")
		if box.next_pos:
			var pos = cam.unproject_position(box.next_pos)
			draw_circle(pos, 5, Color.AQUA)
