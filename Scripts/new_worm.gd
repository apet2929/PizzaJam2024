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

const MOVE_TIMER = 1
const WORM_BODY_SEGMENT_SCENE = preload("res://scenes/worm_body_segment.tscn")
const WORM_SCENE = preload("res://scenes/new_worm.tscn")

@export var worm_length = 4
@export var spawn_points = [ # relative to head position
	Vector3(0, 0, 0),
	Vector3(-1, 0, 0),
	Vector3(-2, 0, 0),
	Vector3(-2, 0, 1)
]

var move_ready = false
var last_dir

@onready var up_ray = $Rays/UpRay
@onready var down_ray = $Rays/DownRay
@onready var left_ray = $Rays/LeftRay
@onready var right_ray = $Rays/RightRay

# self.segments is the 1 source of truth for segment positions
# Body: Contains instances of WormBodySegment
	# positions updated by self.segments
	# order does not matter
# WormBodySegment: handles collision, draws endcaps
	# identified by guid
# Curve & Worm_GFX: Draws body
	# each frame, curve[i] = segments[i]

# Each segment has to have a reference to this because
	# otherwise, the head and the root will be misaligned
	# (segments update after root)

var segments = [] # list of Node3D
var curve: Curve3D

# self.global_position = initial position of the head
# TODO: Is the order of the nodes important? 
func _ready() -> void:
	print("ready")
	$Curve.curve = Curve3D.new()
	curve = $Curve.curve
	print(curve)
	$Worm_GFX.polygon = worm_gfx_polygon_points

	for i in range(1, spawn_points.size()):
		var p = spawn_points[i]
		add_segment_to_end(p)

func add_segment_to_end(pos):
	
	var segment_scene = WORM_BODY_SEGMENT_SCENE.instantiate()
	segment_scene.position = Vector3(pos)
	segments.append(segment_scene)
	$Body.add_child(segment_scene)
	self.curve.add_point(Vector3(pos)) # adds to the end of the curve

func remove_segment(segment):
	# TODO: Depends on segment pos matching its position within the curve. Is this reasonable to expect?
	$Body.remove_child(segment)
	
	var pos = segment.position
	var segment_index = self.curve.curve.get_baked_points().find(pos)
	self.curve.remove_point(segment_index)

func move_to(offset):
	$Body/Head.move_to(self.global_position + offset)

# Important - This is called before the _process fn of all segments
func _process(delta: float) -> void:
	var head_pos = segments[0].position
	self.position += head_pos
	for segment in segments:
		segment.position = segment.position - head_pos
		curve.set_point_position(segments.find(segment), segment.position)
