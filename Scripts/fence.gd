extends StaticBody3D

var open = false

const OPEN_POSITION = Vector3(0, 0, 0)
const CLOSED_POSITION = Vector3(-0.878, 0, -0.96)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	open = false
	# $Pivot/Model/AnimationPlayer.play("Open")
	
func process() -> void:
	if open:
		$CollisionShape3D.transform = Transform3D($CollisionShape3D/OpenPosition.transform)
	else:
		$CollisionShape3D.transform = Transform3D($CollisionShape3D/ClosedPosition.transform)

func open_fence():
	open = true
	print("Opening")
	$Pivot/Model/AnimationPlayer.play("Open")
	
func close_fence():
	open = false
	print("Closing")
	$Pivot/Model/AnimationPlayer.play_backwards("Open")
