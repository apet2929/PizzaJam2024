extends Node

var can_move = false
var next_pos = Vector3(0,0,0)
const SPEED = 100.0

func _process(delta: float) -> void:
	pass

func go_to_position(main_node, target_pos, delta):
	main_node.global_position.x = lerp(main_node.global_position.x, target_pos.x, SPEED * delta)
	main_node.global_position.y = lerp(main_node.global_position.y, target_pos.y, SPEED * delta)
	main_node.global_position.z = lerp(main_node.global_position.z, target_pos.z, SPEED * delta)

func move_to(pos):
	next_pos = pos
	can_move = true
