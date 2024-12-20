extends RigidBody3D
const SPEED = 16
const SNAP_DISTANCE = 0.1
var next_pos
# Called when the node enters the scene tree for the first time.

func _process(delta: float) -> void:
	$Model.position = lerp($Model.position, Vector3(0,0,0), delta * SPEED)

func push(dir) -> bool:
	var blocking_body = cant_move_in(dir)
	if blocking_body:
		return false
	var old_pos = Vector3(self.global_position)
	next_pos = self.position + dir
	self.position = next_pos
	$Model.global_position = old_pos
	return true

func cant_move_in(dir):
	if dir.x < 0 and $Rays/LeftRay.is_colliding():
		return $Rays/LeftRay.get_collider()
	if dir.z < 0 and $Rays/DownRay.is_colliding():
		return $Rays/DownRay.get_collider()
	if dir.x > 0 and $Rays/RightRay.is_colliding():
		return $Rays/RightRay.get_collider()
	if dir.z > 0 and $Rays/UpRay.is_colliding():
		return $Rays/UpRay.get_collider()
	return false

func _on_box_area_body_entered(body: Node3D) -> void:
	EventBus.box_body_entered.emit(self, body)
