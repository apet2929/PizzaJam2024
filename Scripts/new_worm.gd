extends CharacterBody3D

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

const MOVE_TIMER = 0.25
const GRAVITY = -20 # Used to counter a bug that lets you fly
const PUSH_FORCE = 4.0

const WORM_BODY_SEGMENT_SCENE = preload("res://scenes/worm_body_segment.tscn")
const WORM_SCENE = preload("res://scenes/new_worm.tscn")


@export var worm_length = 4
@export var spawn_points = [ # relative to head position
	Vector3(0, 0, 0),
	Vector3(-1, 0, 0),
	Vector3(-2, 0, 0),
	Vector3(-2, 0, 1),
	Vector3(-2, 0, 2),
	Vector3(-2, 0, 3)
]

var move_ready = false
var last_dir = Vector2(0,0) # Stopping the player from going backwards

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
	move_ready = true
	$Curve.curve = Curve3D.new()
	curve = $Curve.curve
	$Worm_GFX.polygon = worm_gfx_polygon_points

	for i in range(spawn_points.size()):
		var p = spawn_points[i]
		self._add_segment_to_end(p)

# Important - This is called before the _process fn of all segments
func _process(delta: float) -> void:
	var dir = Input.get_vector("forward", "backward", "right", "left")
	self.velocity.y = GRAVITY
	
	if move_ready:
		handle_movement(dir)
	
	var old_pos = Vector3(self.global_position)
	move_and_slide()
	var diff = self.global_position - old_pos

	for segment in segments:
		if segment != get_head():
			segment.global_position -= diff
		segment.update(delta)
		
	var head_pos = Vector3(get_head().position)
	if head_pos.x != 0 or head_pos.z != 0:
		push_error("Head not centered! Head at: " + str(head_pos))
	self.position += head_pos
	for segment in segments:
		segment.position -= head_pos
		curve.set_point_position(segments.find(segment), segment.position)

func handle_movement(dir):
	if wall_check(dir):
		return

	# Checking if: Input is pressed, Not trying to move diagonally, Isn't trying to move back inside the worm
	var no_dir = dir == Vector2(0,0)
	var diagonal = (dir.x != 0) and (dir.y != 0)
	var backwards = dir == -last_dir
	if dir.x > 0:
		print("foo")
	if !(no_dir or diagonal or backwards):
		start_move(dir)
		move_ready = false
		
		await get_tree().create_timer(MOVE_TIMER).timeout
		# Snapping the Worm's head to the grid
		self.velocity = Vector3(0,self.velocity.y,0)
		snap_to_grid()
		
		last_dir = dir # Saving the last movement so the player wouldn't be able to go back
		move_ready = true

func start_move(direction):
	print("foo bar")
	self.velocity = Vector3(direction.x, 0, direction.y) * PUSH_FORCE
	#
	## Going through all of the Worm's body parts and telling them to move
	var last_body_pos = self.global_position
	## Head always remains at (0,0,0)
	for i in range(1, segments.size()): # BUG: Depends on order of nodes within segments (fix if causing issues)
		var body = segments[i]
		body.move_to(last_body_pos)
		last_body_pos = body.global_position

func snap_to_grid():
	self.global_position.x = round(self.global_position.x)
	self.global_position.z = round(self.global_position.z)

func wall_check(dir):
	# Returns TRUE if raycast is colliding
	var up_check = (dir.x == -1 and up_ray.is_colliding())
	var down_check = (dir.x == 1 and down_ray.is_colliding())
	var right_check = (dir.y == -1 and right_ray.is_colliding())
	var left_check = (dir.y == 1 and left_ray.is_colliding())
	var colliding = up_check or down_check or right_check or left_check
	return colliding

func get_head():
	return segments[0]

func get_tail():
	return segments[segments.size()-1]



# TODO: Only allow adding and removing from the end!
func add_segment_to_tail(offset_from_tail: Vector3):
	var pos = offset_from_tail + segments[segments.size()-1].position
	self._add_segment_to_end(pos)
	
# Do not call directly, instead add add_segment_to_tail
func _add_segment_to_end(pos):
	var segment_scene = WORM_BODY_SEGMENT_SCENE.instantiate()
	segment_scene.position = Vector3(pos)
	segments.append(segment_scene)
	$Body.add_child(segment_scene)
	
	var p = Vector3(pos)
	var index = curve.point_count
	curve.add_point(p) # adds to the end of the curve
	segment_scene.curve_index = index
	
	set_endcaps()

func remove_segment(segment):
	$Body.remove_child(segment)
	segments.erase(segment)
	self.curve.remove_point(segment.curve_index)
	segment.queue_free()

	set_endcaps()

	if segments.size() == 0:
		print("no segments left, killing self")
		self.queue_free()

func move_to(offset):
	last_dir = offset
	$Body/Head.move_to(self.global_position + offset)

func set_endcaps():
	# makes end-cap spheres visible for endpoints, and invisible for the rest
	for segment in segments:
		segment.get_node("Sphere").visible = false
		
	get_head().get_node("Sphere").visible = true
	get_tail().get_node("Sphere").visible = true


func print_curve():
	var s = "["
	for i in range(0, self.curve.point_count):
		s += str(self.curve.get_point_position(i)) + ", "
	s += "]"
	print(s)
