extends Camera3D

const DISTANCE = 3.3
const FOLLOW_SPEED = 1.8
@onready var worm: Node3D = $"../Complete_Worm/Worm"

func _process(delta: float) -> void:
	self.position.x = lerp(self.position.x, worm.position.x + DISTANCE, FOLLOW_SPEED * delta)
	self.position.z = lerp(self.position.z, worm.position.z + DISTANCE, FOLLOW_SPEED * delta)
