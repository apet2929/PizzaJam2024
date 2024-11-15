extends CharacterBody3D

var move_ready = true
const MOVE_TIMER = 1.0
const GRID_SIZE = 1.0
const PUSH_FORCE = 1.0

@onready var bottom_ray: RayCast3D = $bottomRay
@onready var top_ray: RayCast3D = $topRay
@onready var left_ray: RayCast3D = $leftRay
@onready var right_ray: RayCast3D = $rightRay

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	move_ready = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	move()
	move_and_slide()
	
func move() -> void:
	if move_ready:
		var dir = Input.get_vector("forward", "backward", "right", "left")
		if dir != Vector2(0,0) and abs(dir.x) != abs(dir.y):
			start_move(dir)
			move_ready = false
			await get_tree().create_timer(MOVE_TIMER).timeout
			self.velocity = Vector3(0,0,0)
			
			self.position.x = round(self.position.x)
			self.position.z = round(self.position.z)
			move_ready = true
	
	
func start_move(direction):
	self.velocity = Vector3(direction.x, 0, direction.y) * PUSH_FORCE
