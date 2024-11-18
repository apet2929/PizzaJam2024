extends CharacterBody3D

var move_ready = true
const MOVE_TIMER = 0.25
const GRAVITY = -20 # Used to counter a bug that lets you fly
const PUSH_FORCE = 4.0

# These are the points to make the "Worm_GFX" log like
const points = [
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

var last_dir = Vector2(0,0) # Stopping the player from going backwards
var body_parts: Node3D
var worm_body: Path3D
var worm_gfx: CSGPolygon3D

@onready var down_ray: RayCast3D = $DownRay
@onready var up_ray: RayCast3D = $UpRay
@onready var left_ray: RayCast3D = $LeftRay
@onready var right_ray: RayCast3D = $RightRay

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	move_ready = true
	snap_to_grid()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.velocity.y = GRAVITY
	move()
	move_and_slide()
	worm_body.curve.set_point_position(0, self.position)
	
func move() -> void:
	if move_ready:
		var dir = Input.get_vector("forward", "backward", "right", "left")
		
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
	self.velocity = Vector3(direction.x, 0, direction.y) * PUSH_FORCE
	
	# Going through all of the Worm's body parts and telling them to move
	var last_body_pos = self.position
	for body in body_parts.get_children():
		body.move_to(last_body_pos)
		last_body_pos = body.global_position
	

func wall_check(dir):
	if (dir.x == -1 and up_ray.is_colliding()) or (dir.x == 1 and down_ray.is_colliding()) or (dir.y == -1 and right_ray.is_colliding()) or (dir.y == 1 and left_ray.is_colliding()):
		return false
	
	return true
	
	
func snap_to_grid():
	self.global_position.x = round(self.global_position.x)
	self.global_position.z = round(self.global_position.z)
