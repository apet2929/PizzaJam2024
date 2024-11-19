extends Area3D

var used = false

func drop():
	if not used:
		used = true
		print("dropping")
		$Model/AnimationPlayer.play("drop")
		# enable collision so nothing can pass through the guillotine after its been dropped
		$DroppedCollision.collision_layer = 1 
	
func undrop():
	used = false
	$Model/AnimationPlayer.play_backwards("drop")
	$DroppedCollision.collision_layer = 0
	
func reset():
	$DroppedCollision.collision_layer = 0
	
	
