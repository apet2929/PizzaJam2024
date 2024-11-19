extends Camera3D

const DISTANCE_OFFSET = 2.0
const FOLLOW_SPEED = 1.1
var worms = []


@onready var WORM = preload("res://scenes/worm.tscn")
# Helper function to calculate the midpoint of all worms
func get_midpoint() -> Vector3:
	var total_position = Vector3()
	for worm in worms:
		total_position += worm.get_head().global_position
	return total_position / worms.size()

func _process(delta: float) -> void:
	if worms.size() == 0:
		return  # Avoid division by zero if no worms are available
	
	# Calculate the midpoint of all worms
	var middle_point = get_midpoint()
	var distance = 0.0
	if len(worms) > 1:
		distance = abs((worms[0].global_position.x - worms[1].global_position.x) + (worms[0].global_position.z - worms[1].global_position.z))
	else:
		distance = 15.0
	# Update the camera's position to follow the worms smoothly
	var target_position = middle_point + Vector3(DISTANCE_OFFSET + distance, DISTANCE_OFFSET + distance, DISTANCE_OFFSET + distance)

	# Lerp the camera position smoothly towards the target position
	self.position.x = lerp(self.position.x, target_position.x, FOLLOW_SPEED * delta)
	self.position.y = lerp(self.position.y, target_position.y, FOLLOW_SPEED * delta)
	self.position.z = lerp(self.position.z, target_position.z, FOLLOW_SPEED * delta)
