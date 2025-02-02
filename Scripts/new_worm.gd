extends Node3D

# TODO : make worm smaller
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
const WORM_SCRIPT = preload("res://Scripts/new_worm.gd")
const BOX_SCRIPT = preload("res://Scripts/box.gd")

const MAX_SFX_PITCH = 1.4
const MIN_SFX_PITCH = 0.4

var disabled = false
@export var has_crown = false



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
var current_dir = Vector2(0,0) # For pushing boxes

@onready var up_ray = $Rays/UpRay
@onready var down_ray = $Rays/DownRay
@onready var left_ray = $Rays/LeftRay
@onready var right_ray = $Rays/RightRay

@onready var move_sfx: AudioStreamPlayer3D = $Move_sfx

var segments = [] # list of segments, 0 = head, last = tail
var curve: Curve3D

# TODO : show restart message when softlocked

func _ready() -> void:
	init_signals()
	
	$CSGSphere3D.visible = false
	if has_node("../GameCamera"):
		var camera = get_node("../GameCamera")
		camera.worms.append(self)
	
	move_ready = true
	$Curve.curve = Curve3D.new()
	curve = $Curve.curve
	$Worm_GFX.polygon = worm_gfx_polygon_points
	
	$Body/crown.visible = has_crown

	for i in range(spawn_points.size()):
		var p = spawn_points[i]
		self._add_segment_to_end(p)

# Important - This is called before the _process fn of all segments
func _process(delta: float) -> void:
	if disabled:
		return
	var dir = Input.get_vector("left", "right", "forward", "backward")
	self.velocity.y = GRAVITY
	
	if move_ready:
		handle_movement(dir)

	var should_snap = get_head().update(delta)
	for i in range(1, segments.size()):
		segments[i].update(delta)
	
	if should_snap:
		snap_to_grid()
	
	# Reset scene
	if Input.is_action_just_pressed("retry"):
		get_tree().reload_current_scene()
	
	for segment in segments:
		curve.set_point_position(segments.find(segment), segment.position)
		
	$Body/crown.visible = has_crown
	var head_pos = get_head().position
	$Body/crown.position = Vector3(head_pos.x, $Body/crown.position.y, head_pos.z)
	

func init_signals():
	EventBus.lettuce_body_entered.connect(self._on_lettuce_body_entered)
	EventBus.box_body_entered.connect(self._on_box_body_entered)
	EventBus.salt_body_entered.connect(self._on_salt_body_entered)
	EventBus.spike_entered.connect(self._on_spike_entered)

func is_worm(body: Node3D) -> bool:
	match body.get_script():
		WORM_SCRIPT:
			return true
		_:
			return false

func handle_movement(dir):
	if wall_check(dir):
		return
	if box_check(dir):
		return

	# when the head snaps to the grid, update the snap the worm as a whole
	# Checking if: Input is pressed, Not trying to move diagonally, Isn't trying to move back inside the worm
	var no_dir = dir == Vector2(0,0)
	var diagonal = (dir.x != 0) and (dir.y != 0)
	var backwards = dir == -last_dir
	
	if !(no_dir or diagonal or backwards):
		start_move(dir)
		move_ready = false
		
		await get_tree().create_timer(MOVE_TIMER).timeout
		# Snapping the Worm's head to the grid
		self.velocity = Vector3(0,self.velocity.y,0)
		
		move_sfx.pitch_scale = randf_range(MIN_SFX_PITCH, MAX_SFX_PITCH)
		move_sfx.play()
		
		#snap_to_grid() TODO: Reenable?
		# snap after timer, or snap once you reach the cell?
		
		last_dir = dir # Saving the last movement so the player wouldn't be able to go back
		move_ready = true

# Cut_from_head - the amount of body segments to cut (from the head)
func split(cut_from_head):
	var sp = {} # positions of each segment relative to head
	var spg = {}
	# segment.position isn't valida fter its removed from the tree (no parent to compare to)
	# so I grab the positions now, before they're removed
	for segment in segments:
		sp[segment] = Vector3(segment.position)
		spg[segment] = Vector3(segment.global_position)
	var cut_off = []
	for i in range(max(cut_from_head, 1), segments.size()):
		var seg = self.remove_segment(self.get_tail())
		cut_off.append(seg)
	if self.segments.size() < 2:
		self.die()
	if cut_off.size() < 2:
		return
	
	cut_off.reverse()
	var new_worm = WORM_SCENE.instantiate()
	var positions = []
	var new_head = cut_off[0]
	var new_head_pos = sp[new_head]
	for seg in cut_off:
		var old_pos = sp[seg]
		positions.append(old_pos - new_head_pos)
	new_worm.spawn_points = positions
	get_parent().add_child(new_worm)
	new_worm.global_position = spg[new_head]

func split_at(segment: Node3D):
	if(segments.find(segment) == -1):
		push_error("Segment not in worm! Self=" + str(self) + " Segment = " + str(segment) 
			+ " scene path = " + segment.scene_file_path)
	var index = segments.find(segment)
	split(index)

func kill():
	if has_node("../GameCamera"):
		var camera = get_node("../GameCamera")
		camera.worms.erase(self)
	self.queue_free()
	
func die():
	EventBus.worm_died.emit(self)
	self.kill()

func start_move(direction):
	self.current_dir = direction
	# Going through all of the Worm's body parts and telling them to move
	var last_body_pos = self.global_position + Vector3(direction.x, 0, direction.y)
	for i in range(segments.size()): # BUG: Depends on order of nodes within segments (fix if causing issues)
		var body = segments[i]
		body.move_to(last_body_pos)
		last_body_pos = self.global_position + body.position

func snap_to_grid():
	var head = get_head()
	var old = Vector3(self.global_position)
	self.global_position.x = head.global_position.x
	self.global_position.z = head.global_position.z
	var diff = self.global_position - old
	head.position = Vector3(0,0,0)
	for i in range(1, segments.size()):
		segments[i].position -= diff

func wall_check(dir):
	# Returns TRUE if raycast is colliding
	# Ignore boxes
	var ray = ray_for_dir(dir)
	if !ray:
		return false

	var colliding = ray.is_colliding()
	if colliding:
		# Box, or some other non-wall object
		if ray.get_collider().get_collision_layer() == 16:
			return false
	return colliding

func box_check(dir):
	# Returns TRUE if raycast is colliding wtih a box AND
	# 	the box can't move to where you want to push it
	
	var ray = ray_for_dir(dir)
	if !ray:
		return false
	var d = Vector3(dir.x, 0, dir.y)
	if ray.is_colliding():
		var obj = ray.get_collider()
		if obj.get_script() == BOX_SCRIPT:
			var f = obj.cant_move_in(d)
			return f
	return false

func ray_check_for_obj(worm_dir: Vector2, dir_x: int, dir_y: int, ray: RayCast3D, obj_script):
	if worm_dir.x == dir_x and worm_dir.y == dir_y:
		if ray.is_colliding():
			var obj = ray.get_collider()
			return obj.get_script() == obj_script
	return false

func get_head():
	return segments[0]

func get_tail():
	return segments[segments.size()-1]

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

	if segments.size() <= 1:
		print("no segments left, killing self")
		self.die()
		
	return segment

func ray_for_dir(dir):
	if dir == Vector2(-1,0): 
		return left_ray
	if dir == Vector2(1, 0): 
		return right_ray
	if dir == Vector2(0, -1): 
		return down_ray
	if dir == Vector2(0, 1): 
		return up_ray
	else:
		return null

func move_to(offset):
	last_dir = offset
	$Body/Head.move_to(self.global_position + offset)

func set_endcaps():
	# makes end-cap spheres visible for endpoints, and invisible for the rest
	for segment in segments:
		segment.set_sphere_visible(false)
		#segment.disable_collision() 
		
	var head = get_head()
	head.set_sphere_visible(true)
	head.enable_collision()
	
	var tail = get_tail()
	tail.set_sphere_visible(true)
	tail.enable_collision()

func print_curve():
	var s = "["
	for i in range(0, self.curve.point_count):
		s += str(self.curve.get_point_position(i)) + ", "
	s += "]"
	print(s)


func tail_direction() -> Vector3:
	var tail = get_tail()
	if tail.next_pos != null:
		return Vector3(tail.next_pos - tail.global_position) * -1
	else:
		var tail_parent = segments[segments.size()-2]
		return Vector3(tail_parent.position - tail.position) * -1

# TODO: more logic to prevent spawning new node inside a wall 
func _on_lettuce_body_entered(lettuce, body) -> void:
	if body == get_head().get_node("RigidBody3D"):
		lettuce.queue_free()
		var dir = tail_direction()
		self.add_segment_to_tail(dir)
		
func _on_box_body_entered(box, body) -> void:
	if body == self:
		var d = Vector3(current_dir.x, 0, current_dir.y)
		box.push(d)
		
func _on_salt_body_entered(salt, body) -> void:
	print(body)
	if body == get_head().get_node("RigidBody3D"):
		salt.queue_free()
		self.remove_segment(self.get_tail())

func _on_spike_entered(_spike, body) -> void:
	if body == self:
		self.die()
