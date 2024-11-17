extends Node3D

# keep track of direction facing
# 
enum Direction { # by convention, up = top right
	LEFT=0,
	UP=1,
	RIGHT=2,
	DOWN=3
}

enum RotationDirection {
	CLOCKWISE=-1,
	COUNTER_CLOCKWISE=1
}

# each segment:
#	global position
#	next position
#	speed
# 
# 


var t = 0
var v = 0
var route_index = 0
var segments = ["seg0", "seg1", "seg2", "seg3"]
const Z_AXIS = Vector3(0.0, 0.0, 1.0)

const direction_vectors = {
	Direction.UP: Vector3(0, 0, 1),
	Direction.DOWN: Vector3(0, 0, -1),
	Direction.LEFT: Vector3(-1, 0, 0),
	Direction.RIGHT: Vector3(1, 0, 0)
}

var route = [
	Direction.LEFT,
	Direction.LEFT,
	Direction.LEFT,
	Direction.UP,
]

var transforms = [
	null, null, null, null
]

var foo = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var skeleton = $worm/Armature/Skeleton3D
	var head_id = skeleton.find_bone("seg3")
	set_transforms()
	foo = skeleton.get_bone_global_pose(head_id)
	
func set_transforms():
	var skeleton = $worm/Armature/Skeleton3D
	for i in range(0, segments.size()):
		var seg = segments[i]
		var bone_id = skeleton.find_bone(seg)
		var transform = skeleton.get_bone_pose(bone_id)
		transforms[i] = transform

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:	
	t += delta / 2

	if t > 1:
		t = 0
		v = 0
		route_index += 1
		set_transforms()
		#for transform in transforms:
			#print(transform)
		#print("\n\n")
		

	if route_index >= route.size():
		return
	
	var old_v = v
	v = lerp(0., PI/2, t) # or some other easing function
	var dv = v - old_v
	
	for seg_id in range(0, segments.size()):
		update_seg(seg_id, route_index, v)
	#update_seg(segments.size()-1, route_index, v)


func update_seg(seg_id, route_index, v):
	var skeleton = $worm/Armature/Skeleton3D
	var old_transform = transforms[seg_id]
	var seg = segments[seg_id]
	var bone_id = skeleton.find_bone(seg)
	var target_transform = null
	if seg_id == segments.size()-1: # current bone is the head
		target_transform = transforms[seg_id]
		var target_position = foo.origin + direction_vectors[route[route_index]]
		#target_transform = target_transform.translated(direction_vectors[route[route_index]])
		#print(rotation_vectors[route[route_index]])
		#
		#print(target_position)
		
		var theta = direction_vectors[Direction.UP].angle_to(direction_vectors[Direction.LEFT])
		print("", foo.origin, target_position, theta)
		target_transform = target_transform.rotated(Vector3(0,0, 1), theta)
		var new_transform = old_transform.interpolate_with(target_transform, v)
		skeleton.set_bone_pose(bone_id, new_transform)
		return
	else:
		#target_transform = transforms[seg_id+1]
		return
		
	var new_transform = old_transform.interpolate_with(target_transform, v)
	#var new_transform = old_transform
	skeleton.set_bone_pose(bone_id, new_transform)

	
	

#func rotate_worm(route_index, dv):
	#var old_dirs = route[route_index]
	#if route_index != 0:
		#old_dirs = route[route_index-1]
	#
	#for i in range(0, segments.size()):
		#rotate_seg(i, old_dirs[i], route[route_index][i], dv)

#func rotate_seg(seg_id, old_direction, new_direction, dv):
	#var skeleton = $worm/Armature/Skeleton3D
	#var rotation_direction = rotate_direction(old_direction, new_direction)
	#_rotate_individual_seg(skeleton, seg_id, seg_id, rotation_direction, dv)
	#if seg_id != segments.size()-1:
		#_rotate_individual_seg(skeleton, seg_id+1, seg_id, rotation_direction, dv)

# helper function for rotate_seg
#func _rotate_individual_seg(skeleton, seg_id, base, rotation_direction, dv):
	#var seg = segments[seg_id]
	#var bone_id = skeleton.find_bone(seg)
	#var transform = skeleton.get_bone_pose(bone_id)
	#if seg_id != base:
		#rotation_direction *= -1
	#
	#var new_transform = transform.rotated(Z_AXIS, dv * rotation_direction)
	#skeleton.set_bone_pose(bone_id, new_transform)

	#var old_direction_transform = transform.looking_at(direction_vectors[old_direction])
	#var rotation_amount = lerp(0., PI/2.0, t/10)
	#var new_transform = old_direction_transform.rotated(Z_AXIS, rotation_amount)
	
# returns 1 if you need to rotate 
#func rotate_direction(old_direction, new_direction):
	#if old_direction == new_direction:
		#return 0
#
	#if old_direction == Direction.LEFT:
		#if new_direction == Direction.UP:
			#return RotationDirection.CLOCKWISE
		#elif new_direction == Direction.DOWN:
			#return RotationDirection.COUNTER_CLOCKWISE
	#if old_direction == Direction.RIGHT:
		#if new_direction == Direction.UP:
			#return RotationDirection.COUNTER_CLOCKWISE
		#elif new_direction == Direction.DOWN:
			#return RotationDirection.CLOCKWISE
	#if old_direction == Direction.UP:
		#if new_direction == Direction.LEFT:
			#return RotationDirection.COUNTER_CLOCKWISE
		#elif new_direction == Direction.RIGHT:
			#return RotationDirection.CLOCKWISE
	#if old_direction == Direction.DOWN:
		#if new_direction == Direction.LEFT:
			#return RotationDirection.CLOCKWISE
		#elif new_direction == Direction.RIGHT:
			#return RotationDirection.COUNTER_CLOCKWISE
	#
#func rotate_individual_seg(seg_id, amount):
	#pass

	
#	keyframes
	#if t > 0 and t < 1:
		#$worm.position.x += delta
	#elif t > 1 and t < 2:
		#$worm.position.y += delta
	
