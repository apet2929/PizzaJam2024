extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	var cam: Camera3D = $"../../Camera3D"
	var worm = $"../../Worm"
	var pos = cam.unproject_position(worm.global_position)
	draw_circle(pos, 5, Color.AQUA)
