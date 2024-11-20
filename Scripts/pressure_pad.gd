extends Area3D

var on_btn = false
var part_on_pad = 0
var part_left_pad = 0
@export var gate : Node3D

const worm_timer = 0.0 # The time it takes for a worm to move
var counter = 0.0

func _process(delta: float) -> void:
	if part_on_pad != 0 and part_on_pad == part_left_pad:
		on_btn = false
		part_on_pad = 0
		part_left_pad = 0
	elif on_btn == false:
		if counter > 0:
			counter -= delta
		else:
			gate.drop()
			on_btn = true
			counter = worm_timer
	elif part_on_pad != 0 and part_on_pad != part_left_pad and gate.used == true:
		gate.undrop()

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("body"):
		part_on_pad += 1

func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("body"):
		part_left_pad += 1
