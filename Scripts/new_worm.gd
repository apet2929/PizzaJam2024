extends Node3D

const worm_gfx_polygon_points = [
		Vector2(0.5, 0.0),
		Vector2(0.46194, 0.191341),
		Vector2(0.353553, 0.353553),
		Vector2(0.191341, 0.46194),
		Vector2(0.0, 0.5),
		Vector2(-0.191341, 0.46194),
		Vector2(-0.353553, 0.353553),
		Vector2(-0.46194, 0.191341),
		Vector2(-0.5, 0.0),
		Vector2(-0.46194, -0.191341),
		Vector2(-0.353553, -0.353553),
		Vector2(-0.191341, -0.46194),
		Vector2(0.0, -0.5),
		Vector2(0.191341, -0.46194),
		Vector2(0.353553, -0.353553),
		Vector2(0.46194, -0.191341),
		Vector2(0.5, 0.0)
	]

const WORM_BODY_SEGMENT_SCENE = preload("res://scenes/worm_body_segment.tscn")

@export var worm_length = 4
@export var spawn_points = [ # relative to head position
	Vector3(-1, 0, 0),
	Vector3(-2, 0, 0),
	Vector3(-2, 0, 1)
]

# self.global_position = initial position of the head
func _ready() -> void:
	$Worm_GFX.polygon = worm_gfx_polygon_points
	$Curve.curve.add_point(self.global_position)
	for i in range(spawn_points.size()):
		var p = spawn_points[i]
		add_segment(p, i)

	$Body/Tail.position = spawn_points[spawn_points.size()-1]

func add_segment(pos, id):
	var segment = WORM_BODY_SEGMENT_SCENE.instantiate()
	segment.position = pos
	segment.segment_id = id
	$Curve.curve.add_point(self.global_position + pos)
	
func move(offset):
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
