extends RigidBody3D
const SPEED = 8
const SNAP_DISTANCE = 0.1
var next_pos
# Called when the node enters the scene tree for the first time.

func _process(_delta: float) -> void:
	pass

func push(dir) -> void:
	print(dir)
	next_pos = self.position + dir
	self.position = next_pos

func calc_vel() -> Vector3:
	return Vector3(Vector3.ZERO)
	#var diff = Vector3(next_pos - self.position)
	#if diff.length() < SNAP_DISTANCE:
		#print("snapping to ", next_pos)
		#self.position = next_pos
		#next_pos = null
		#return Vector3(Vector3.ZERO)
	#else:
		#return diff.normalized() * SPEED

func _on_box_area_body_entered(body: Node3D) -> void:
	print("box body enterred: ", str(body))
	EventBus.box_body_entered.emit(self, body)
