extends Camera3D

const DISTANCE_OFFSET : float = 8.0
const FOLLOW_SPEED : float = 0.7
const MIN_CAMERA_SIZE : float = 10.0
const CAMERA_DISTANCE : float = 50.0
const CAMERA_HEIGHT : float = 20.0
const Y_CHANGE = -30
const START_VEC = Vector3(7.925, 20, 11)

# Array to hold the player nodes (worms)
var worms : Array = []

func _ready():
	self.position = START_VEC
	# Check if worms are empty and if so, fetch them from the group "worms"
	if len(worms) <= 0:
		worms = get_tree().get_nodes_in_group("worms")
	
	# Ensure the camera is adjusted to fit all worms
	update_camera_view(0.0)

func _process(delta):
	# Ensure the camera keeps following the group of worms dynamically
	if len(worms) > 0:
		update_camera_view(delta)
		follow_worms(delta)

func update_camera_view(delta):
	if len(worms) <= 0:
		return
	
	# Initialize min and max positions based on the first worm's position
	var min_pos = worms[0].global_transform.origin
	var max_pos = min_pos
	
	# Loop through the worms and find the bounding box that fits all worms
	for worm in worms:
		var worm_pos = worm.global_transform.origin
		
		# Manually calculate min and max for each component
		min_pos.x = min(min_pos.x, worm_pos.x)
		min_pos.y = min(min_pos.y, worm_pos.y)
		min_pos.z = min(min_pos.z, worm_pos.z)
		
		max_pos.x = max(max_pos.x, worm_pos.x)
		max_pos.y = max(max_pos.y, worm_pos.y)
		max_pos.z = max(max_pos.z, worm_pos.z)
	
	# Calculate the center of the bounding box
	var center = (min_pos + max_pos) / 2
	
	# Ensure the camera's y position is at a fixed height above the worms
	self.position.x = lerp(self.position.x, center.x - Y_CHANGE, FOLLOW_SPEED * delta)
	self.position.y = lerp(self.position.y, CAMERA_HEIGHT, FOLLOW_SPEED * delta)
	self.position.z = lerp(self.position.z, center.z - Y_CHANGE, FOLLOW_SPEED * delta)
	
	# Calculate the size needed to fit all the worms in the camera's view
	var worm_size = max(max_pos.x - min_pos.x, max_pos.z - min_pos.z) / 1.5 + DISTANCE_OFFSET
	
	self.size = lerp(self.size, max(worm_size, MIN_CAMERA_SIZE), FOLLOW_SPEED * delta)

func follow_worms(delta):
	# Calculate the center position of all worms
	var average_pos = Vector3.ZERO
	for worm in worms:
		average_pos += worm.global_transform.origin
	average_pos /= len(worms)
	
	# Smoothly move the camera towards the average position of the worms
	var target_position = Vector3(average_pos.x, CAMERA_HEIGHT, average_pos.z)
	global_transform.origin = global_transform.origin.lerp(target_position, FOLLOW_SPEED * delta)
