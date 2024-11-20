extends Area3D

var used = false
var worm_head = null
var parts_on = 0
var parts_left = 0

func drop():
	used = true
	$Model/AnimationPlayer.play("drop")
	# enable collision so nothing can pass through the guillotine after its been dropped
	$DroppedCollision.collision_layer = 1
	
	if worm_head != null:
		worm_head.split(parts_left)
		worm_head = null
		parts_on = 0
		parts_left = 0
	
func undrop():
	used = false
	$Model/AnimationPlayer.play_backwards("drop")
	$DroppedCollision.collision_layer = 0
	
func reset():
	$DroppedCollision.collision_layer = 0
	

func _on_worm_check_body_entered(body: Node3D) -> void:
	if body.is_in_group("body"):
		parts_on += 1
	
	if body.is_in_group("head"):
		worm_head = body

func _on_worm_check_body_exited(body: Node3D) -> void:
	if body.is_in_group("body"):
		parts_left += 1
