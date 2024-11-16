extends Node

var can_move = false
var next_pos = Vector3(0,0,0)
const SPEED = 8.0
const SNAP_SPEED = 12.0
const DISTANCE_FROM_NEXT_POINT = 0.1

@export var worm_body: Path3D

func _process(delta: float) -> void:
	if can_move:
		go_to_position(self, next_pos, delta)
		if self.global_position.distance_to(next_pos) <= DISTANCE_FROM_NEXT_POINT:
			can_move = false
			snap_to_grid(self)
			update_worm_body()


func go_to_position(main_node, target_pos, delta):
	main_node.global_position.x = lerp(main_node.global_position.x, target_pos.x, SPEED * delta)
	main_node.global_position.y = lerp(main_node.global_position.y, target_pos.y, SPEED * delta)
	main_node.global_position.z = lerp(main_node.global_position.z, target_pos.z, SPEED * delta)
	
	update_worm_body()


func move_to(pos):
	next_pos = pos
	can_move = true


# Updating the connection between the worm and the Worm_body path
func update_worm_body():
	# This gets the body part's index in the worm_body path
	var my_name = self.name
	var current_index = int(my_name.substr(4, my_name.length() - 4))
	worm_body.curve.set_point_position(current_index, self.global_position)


func snap_to_grid(node):
	node.global_position.x = round(self.global_position.x)
	node.global_position.z = round(self.global_position.z)
