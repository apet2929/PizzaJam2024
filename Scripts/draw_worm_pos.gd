extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	if has_node("../../Worm") and has_node("../../GameCamera"):
		var worm = get_node("../../Worm")
		var cam = get_node("../../GameCamera")
		var pos = cam.unproject_position(worm.global_position)
		draw_circle(pos, 5, Color.AQUA)
		if has_node("../../Guillotine"):
			var guillotine = get_node("../../Guillotine")
			for body in guillotine.parts_in:
				pos = cam.unproject_position(body.global_position)
				draw_circle(pos, 5, Color.BISQUE)
