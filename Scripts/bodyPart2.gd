extends Node

var can_move = false
var next_pos = Vector3(0,0,0)
var skeleton = null
var bone_id = null
const SPEED = 8.0
const SNAP_SPEED = 12.0
const DISTANCE_FROM_NEXT_POINT = 0.1

@export var worm_body: Path3D

func _process(delta: float) -> void:
	if can_move:
		go_to_position(self, next_pos, delta)

func go_to_position(main_node, target_pos, delta):
#	todo: rotation
	var current_transform = skeleton.get_bone_pose(bone_id)
	current_transform.origin = lerp(current_transform.origin, target_pos, SPEED * delta)
	#current_transform = current_transform.rotated(Vector3(0,0,1), )
	skeleton.set_bone_pose(bone_id, current_transform)
	
func set_position(position):
	var t = skeleton.get_bone_pose(self.bone_id)
	t.origin = position
	skeleton.set_bone_pose(self.bone_id, t)

func move_to(pos):
	next_pos = pos
	can_move = true

func snap_to_grid(node):
	var t = skeleton.get_bone_pose(self.bone_id)
	t.origin = next_pos
	skeleton.set_bone_pose(self.bone_id, t)
	print(t.origin)
