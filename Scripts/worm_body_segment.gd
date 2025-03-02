extends Node3D

class_name WormBodySegment

var next_pos # global coordinates, not local
const SPEED = 4

signal move_done

var t = 0
var curve_index
var last_pos: Vector3

# Animation curve defining how 
var movement_curve: Curve2D = Curve2D.new()

func _ready() -> void:
	movement_curve.add_point(Vector2(0,0))
	movement_curve.add_point(Vector2(1,1))
	
	movement_curve.set_point_out(0, Vector2(0, 0))
	
	#movement_curve.set_point_in(1, Vector2(0, 0)) # lerp
	# movement_curve.set_point_in(1, Vector2(0, -0.75)) # slow start, quick end
	movement_curve.set_point_in(1, Vector2(-0.75, 0)) # quick start, slow end

# ----! WormBodySegment does not set any attributes of its parents for simplicity sake !---- #
# curve_index and next_pos are set by new_worm.gd
# returns: whether the node snapped into place
func update(delta: float):
	if curve_index == null:
		push_error("segment " + str(self) + " at " + str(self.position) + " has no curve index!")
	
	# TODO: Replace with AnimationPlayer?
	if next_pos != null:
		t += delta * SPEED
		if should_snap(delta):
			set_global_position(self.next_pos)
			last_pos = self.global_position
			next_pos = null
			t = 0
			move_done.emit()
			return true
		
		var new_pos = get_pos_at(t)
		set_global_position(new_pos)

func get_pos_at(time):
	var anim_t = movement_curve.sample(0, time).y
	return lerp(last_pos, self.next_pos, anim_t)

func set_sphere_visible(_is_visible):
	$Sphere.visible = _is_visible

func enable_collision():
	call_deferred("_set_collision_disabled", false)

func disable_collision():
	call_deferred("_set_collision_disabled", true)

func _set_collision_disabled(is_disabled):
	$RigidBody3D/CollisionShape3D.disabled = is_disabled

func move_to(pos):
	last_pos = self.global_position
	next_pos = pos

# We snap if we would go over the target position next frame- jumpback looks goofy
func should_snap(delta):
	#var diff = self.global_position - next_pos
	#return diff.length_squared() < 0.1
	return t + (delta * SPEED) >= 1

func snap_to_grid(_node, _delta):
	self.global_position.x = round(self.global_position.x)
	self.global_position.z = round(self.global_position.z)
