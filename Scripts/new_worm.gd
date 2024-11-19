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
var segments = [] # List of Vector3, positions relative to body (head at 0,0,0 by convention)
@onready var curve: Path3D = $Curve
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


# self.global_position = initial position of the head
# TODO: Is the order of the nodes important? 
func _ready() -> void:
	segments.append_array(spawn_points)
	$Worm_GFX.polygon = worm_gfx_polygon_points
	var head = $Body/Head
	var segment_id = ResourceUID.create_id()
	
	head.position = segments[0]
	for i in range(1, spawn_points.size()):
		var p = spawn_points[i]
		add_segment_to_end(p)

func add_segment_to_end(pos):
	segments.append(pos)
	var segment_scene = WORM_BODY_SEGMENT_SCENE.instantiate()
	segment_scene.position = pos
	$Body.add_child(segment_scene)
	self.curve.curve.add_point(pos) # adds to the end of the curve

func remove_segment(segment):
	# TODO: Depends on segment pos matching its position within the curve. Is this reasonable to expect?
	$Body.remove_child(segment)
	
	var pos = segment.position
	var segment_index = self.curve.curve.get_baked_points().find(pos)
	self.curve.curve.remove_point(segment_index)

func move_to(offset):
	$Body/Head.move_to(self.global_position + offset)

# Important - This is called before the _process fn of all segments
func _process(delta: float) -> void:
	var segments = get_segments()
	update_segments()
	var head_pos = segments[0].position
	self.position += head_pos
	for segment in segments:
		segment.position = segment.position - head_pos
		curve.curve.set_point_position(segment.segment_id, segment.position)

func update_segments():
	var segments = get_segments()
	
	segments[0].get_node("Sphere").visible = true
	segments[segments.size()-1].get_node("Sphere").visible = true
	
	for i in range(1, segments.size()-1):
		segments[i].is_end_segment = false

func split():
	var new_worm = WORM_SCENE.instantiate()
	new_worm.spawn_points.clear()
	
	var segs = get_segments()
	var start = segs.size() / 2
	var end = segs.size()-1
	if end - start < 2:
		print("can't split, too short")
		return
		
	new_worm.global_position = segs[start].global_position
	var head_pos = segs[start].position
	for i in range(start, end):
		new_worm.spawn_points.append(segs[i].position - head_pos)
		self.remove_segment(segs[i])
		# TODO: Adjust segment ids
		# TODO: remove id from add_segment func
		# TODO: test splitting
		# TODO: test instantiating the scene from code
		# TODO: debug why having more than 1 worm fucks things up

func move(dir) -> void:
	if move_ready:
		
		if not wall_check(dir):
			return
		
		# Checking if: Input is pressed, Not trying to move diagonally, Isn't trying to move back inside the worm
		if dir != Vector2(0,0) and abs(dir.x) != abs(dir.y) and dir != -last_dir:
			start_move(dir)
			move_ready = false
			await get_tree().create_timer(MOVE_TIMER).timeout
			
			# Snapping the Worm's head to the grid
			self.velocity = Vector3(0,self.velocity.y,0)
			snap_to_grid()
			
			last_dir = dir # Saving the last movement so the player wouldn't be able to go back
			move_ready = true

func start_move(direction):
	# Going through all of the Worm's body parts and telling them to move
	var last_body_pos = self.global_position + direction
	var segs = self.get_segments()
	
	for i in range(0, segs.size()):
		segs[i].move_to(last_body_pos)
		last_body_pos = segs[i].global_position

func wall_check(dir):
	if (dir.x == -1 and up_ray.is_colliding()) or (dir.x == 1 and down_ray.is_colliding()) or (dir.y == -1 and right_ray.is_colliding()) or (dir.y == 1 and left_ray.is_colliding()):
		return false
	
	return true
	
func snap_to_grid():
	self.global_position.x = round(self.global_position.x)
	self.global_position.z = round(self.global_position.z)
	
	
	
	
