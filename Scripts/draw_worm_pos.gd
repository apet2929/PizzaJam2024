extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	if has_node("../../Worm") and has_node("../../GameCamera"):
		var worm = get_node("../../Worm")
		var cam = get_node("../../GameCamera")
		var pos = cam.unproject_position(worm.global_position)
		
		draw_circle(pos, 5, Color.AQUA)

		var hpos = cam.unproject_position(worm.get_head().global_position)
		draw_circle(hpos, 5, Color.DARK_BLUE)
		
		for segment in worm.segments:
			if segment.next_pos:
				var npos = cam.unproject_position(segment.next_pos)
				draw_circle(npos, 3, Color.YELLOW_GREEN)
		
		if worm.get_node("Rays/RightRay").is_colliding():
			var c = worm.get_node("Rays/RightRay").get_collider()
			pos = cam.unproject_position(c.global_position)
			
		if has_node("../../Guillotine"):
			var guillotine = get_node("../../Guillotine")
			for body in guillotine.parts_in:
				pos = cam.unproject_position(body.global_position)
				draw_circle(pos, 5, Color.BISQUE)
