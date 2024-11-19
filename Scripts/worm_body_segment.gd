extends Node3D

var can_move = false
var next_pos # global coordinates, not local
const SPEED = 8
const SNAP_SPEED = 12.0
const DISTANCE_FROM_NEXT_POINT = 0.1

var parent: Node3D

# ----! WormBodySegment does not reference its parents at all for simplicity sake !---- #
# it doesn't even know what position within the worm it is! 

func _process(delta: float) -> void:
	if can_move and next_pos != null:
		go_to_position(self, next_pos, delta)
		if self.global_position.distance_to(next_pos) <= DISTANCE_FROM_NEXT_POINT:
			next_pos = null
			can_move = false
			snap_to_grid(self)

func go_to_position(main_node, target_pos, delta):
	set_global_position(lerp(self.global_position, self.next_pos, SPEED * delta))

func move_to(pos):
	next_pos = pos
	can_move = true

func snap_to_grid(node):
	print("snapping")
	self.global_position.x = round(self.global_position.x)
	self.global_position.z = round(self.global_position.z)