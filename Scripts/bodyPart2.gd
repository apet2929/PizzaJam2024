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
	
	var temp = current_transform.origin
	
	# rotation
	var a = Vector2(current_transform.origin.x, current_transform.origin.z)
	var b = Vector2(target_pos.x, target_pos.z)
	if a.distance_to(b) > 0.001:
		var temp_target = target_pos
		temp_target.y = 1
		current_transform = current_transform.looking_at(temp_target) # rotate around correct axis
	
	current_transform.origin = lerp(current_transform.origin, target_pos, SPEED * delta)
	
	skeleton.set_bone_pose(bone_id, current_transform)

func get_position():
	var t = skeleton.get_bone_pose(self.bone_id)
	return t.origin

func set_position(position):
	var t = skeleton.get_bone_pose(self.bone_id)
	t.origin = position
	skeleton.set_bone_pose(self.bone_id, t)

func move_to(pos):
	next_pos = pos
	can_move = true
	
	print(next_pos)

func snap_to_grid(node):
	var t = skeleton.get_bone_pose(self.bone_id)
	t.origin = next_pos
	skeleton.set_bone_pose(self.bone_id, t)
	print(t.origin)
	
