extends Node3D

var can_move = false
var next_pos # global coordinates, not local
const SPEED = 12
const SNAP_SPEED = 40.0
const DISTANCE_FROM_NEXT_POINT = 0.1

var curve_index

# ----! WormBodySegment does not set any attributes of its parents for simplicity sake !---- #
# curve_index and next_pos are set by new_worm.gd
# returns: whether the node snapped into place
func update(delta: float):
	if curve_index == null:
		push_error("segment " + str(self) + " at " + str(self.position) + " has no curve index!")
	
	if can_move and next_pos != null:
		go_to_position(self, next_pos, delta)
		if self.global_position.distance_to(next_pos) <= DISTANCE_FROM_NEXT_POINT:
			next_pos = null
			can_move = false
			snap_to_grid(self, delta)
			return true 

func set_sphere_visible(_is_visible):
	$Sphere.visible = _is_visible

func enable_collision():
	call_deferred("_set_collision_disabled", false)

func disable_collision():
	call_deferred("_set_collision_disabled", true)

func _set_collision_disabled(is_disabled):
	$RigidBody3D/CollisionShape3D.disabled = is_disabled

func go_to_position(_main_node, _target_pos, delta):
	set_global_position(lerp(self.global_position, self.next_pos, SPEED * delta))

func move_to(pos):
	next_pos = pos
	can_move = true

func snap_to_grid(_node, _delta):
	self.global_position.x = round(self.global_position.x)
	self.global_position.z = round(self.global_position.z)
