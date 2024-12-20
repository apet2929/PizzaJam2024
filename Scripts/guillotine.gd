extends Area3D

var used = false
var worm_head = null
var parts_on = 0
var parts_left = 0
var parts_in = []
@export var one_way = false # if you want the guillotine to function as a 1-way door,
							# you need different collision (CollisionShape3D2)

@onready var blood_particle: GPUParticles3D = $Model/blood_particle
@onready var drop_sfx: AudioStreamPlayer3D = $Model/drop_sfx

func ready():
	if one_way:
		$DroppedCollision.remove_child($DroppedCollision/CollisionShape3D)
		$WormCheck.remove_child($WormCheck/CollisionShape3D)
	else:
		$DroppedCollision.remove_child($DroppedCollision/OneWayCollision)
		$WormCheck.remove_child($WormCheck/OneWayCollision)
	

func drop():
	if !used:
		used = true
		drop_sfx.play()
		$Model/AnimationPlayer.play("drop")
		# enable collision so nothing can pass through the guillotine after its been dropped
		$DroppedCollision.collision_layer = 2
		if !parts_in.is_empty():
			var body: Node3D = parts_in[0] # RigidBody3D
			var segment = body.get_parent() # RigidBody3D > WormBodySegment
			var body_root = segment.get_parent() # WormBodySegment > Body
			var worm_root = body_root.get_parent() # Body > Worm
			
			if worm_root != null:
				worm_root.split_at(segment)
			
			blood_particle.emitting = true

func play_particle_effect():
	blood_particle.emitting = true

func undrop():
	used = false
	$Model/AnimationPlayer.play_backwards("drop")
	$DroppedCollision.collision_layer = 0

func reset():
	$DroppedCollision.collision_layer = 0

func _on_worm_check_body_entered(body: Node3D) -> void:
	if body.is_in_group("body") and !body.is_in_group("head"):
		parts_in.append(body)

func _on_worm_check_body_exited(body: Node3D) -> void:
	if body.is_in_group("body"):
		parts_in.erase(body)
