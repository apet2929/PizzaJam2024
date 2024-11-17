extends Control



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	queue_redraw()

func _draw():
	var skeleton = %Model/Armature/Skeleton3D
	var color = Color(0, 1, 0)
	self.draw_line(Vector2(0,0), Vector2(100,100), color, 2)
	for i in range(0, 4):
		var t = skeleton.get_bone_pose(i)
		var to = t.origin + %Model.global_transform.origin
		var start = %Camera3D.unproject_position(to)
		var end = %Camera3D.unproject_position(to - (t.basis.z * 5))
		self.draw_line(start, end, color, 2)
		end = %Camera3D.unproject_position(to + (t.basis.x * 5))
		self.draw_line(start, end, color, 2)
		end = %Camera3D.unproject_position(to + (t.basis.y * 5))
		self.draw_line(start, end, color, 2)
		color.r += 0.2
		color.g -= 0.2
