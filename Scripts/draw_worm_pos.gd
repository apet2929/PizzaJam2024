extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	var cam: Camera3D = $"../../GameCamera"
	var worm = $"../../Worm"
	if cam and worm:
		var pos = cam.unproject_position(worm.global_position)
		draw_circle(pos, 5, Color.AQUA)
