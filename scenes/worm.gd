extends CharacterBody3D

var move_ready = true
const MOVE_TIMER = 1.0
const GRID_SIZE = 1.0
const PUSH_FORCE = 1.0

# These are the points to make the "Worm_GFX" circular
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

const HEAD_OFFSET = Vector3(0,0,0.0)
@onready var body_parts: Node3D = $"../BodyParts"
@onready var worm_body: Path3D = $"../worm_body"
@onready var worm_gfx: CSGPolygon3D = $"../Worm_GFX"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	move_ready = true
	snap_to_grid()
	worm_body.curve.add_point(self.position + HEAD_OFFSET)
	for body in body_parts.get_children():
		worm_body.curve.add_point(body.global_position)
	
	worm_gfx.polygon = points


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	move()
	move_and_slide()
	worm_body.curve.set_point_position(0, self.position + HEAD_OFFSET)
	
func move() -> void:
	if move_ready:
		var dir = Input.get_vector("forward", "backward", "right", "left")
		if dir != Vector2(0,0) and abs(dir.x) != abs(dir.y):
			var last_pos = self.global_position
			start_move(dir)
			move_ready = false
			await get_tree().create_timer(MOVE_TIMER).timeout
			self.velocity = Vector3(0,0,0)
			
			snap_to_grid()
			if self.position.x != round(last_pos.x) or self.position.z != round(last_pos.z):
				worm_body.curve.clear_points()
				worm_body.curve.add_point(self.position + HEAD_OFFSET)
				
				for body in body_parts.get_children():
					var temp = body.global_position
					body.global_position = last_pos
					last_pos = temp
					worm_body.curve.add_point(body.global_position)
			
			move_ready = true
	
	
func start_move(direction):
	self.velocity = Vector3(direction.x, 0, direction.y) * PUSH_FORCE
	
func snap_to_grid():
	self.position.x = round(self.position.x)
	self.position.z = round(self.position.z)
