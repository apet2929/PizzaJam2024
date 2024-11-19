extends Control

func _process(delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	var cam: Camera3D = $"../../Camera3D"
	
	if has_node("../../Worm/Body"):
		var worm = get_node("../../Worm/Body")	
		var pos = cam.unproject_position(worm.global_position)
		draw_circle(pos, 5, Color.AQUA)
