extends Node3D

var move_ready = false
const MOVE_TIMER = 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var move_ready = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func move(direction) -> void:
	if move_ready:
		start_move(direction)
		move_ready = false
		await get_tree().create_timer(MOVE_TIMER).timeout
		move_ready = true
	
	
func start_move(direction):
	pass
