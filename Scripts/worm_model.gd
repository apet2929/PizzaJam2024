extends Node3D


var bones = []
var prev_positions = []
var target_positions = []
var prev_transforms = []
var target_transforms = []
var target_transforms_2 = []
var t = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var skel = $Armature/Skeleton3D
	bones.append(skel.find_bone("tail"))
	bones.append(skel.find_bone("body1"))
	bones.append(skel.find_bone("body2"))
	bones.append(skel.find_bone("head"))
	
	run()
	
func run():
	var skel = $Armature/Skeleton3D
	target_transforms = [
		skel.get_bone_pose(bones[0]),
		skel.get_bone_pose(bones[1]),
		skel.get_bone_pose(bones[2]),
		skel.get_bone_pose(bones[3]),
	]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var skel = $Armature/Skeleton3D
	t += delta
	#
	for i in range(0, bones.size()):
		foo(skel, i, t)
	
func foo(skel, i, t):
	var tt = target_transforms[i]
	tt = tt.translated(Vector3(t, 0, 0))
	skel.set_bone_pose(bones[i], tt)
	
func move_to(position):
	var skel = $Armature/Skeleton3D
	prev_positions = target_positions.duplicate()
	target_positions.push_back(position)
	target_positions.pop_front()
	
	for i in range(0, bones.size()):
		print(bones[i])
		print(target_transforms[i].origin)
		skel.set_bone_pose(bones[i], target_transforms[i])
	
	prev_transforms.clear()
	target_transforms.clear()
	for i in range(0, bones.size()):
		var current = skel.get_bone_pose(bones[i])
		prev_transforms.append(current)
		var theta = prev_positions[i].angle_to(target_positions[i])
		var target_transform = current.rotated(Vector3(0,0, 1), theta)
		target_transform = target_transform.translated(target_positions[i] - prev_positions[i])
		target_transforms.append(target_transform)
	
