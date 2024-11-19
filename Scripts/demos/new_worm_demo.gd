extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#$NewWorm.position += Vector3(1 * delta, 0, 0)
	#var dir = Input.get_vector("forward", "backward", "right", "left")
	#$NewWorm.start_move(dir)
	pass
	
	#if Input.is_action_just_released("forward"):
		#var dir = Vector2(1,0)
		#$NewWorm.handle_movement(dir)
		#print($NewWorm.velocity)
		#for segment in $NewWorm.segments:
			#print(segment.next_pos)
		#$NewWorm.add_segment_to_tail(Vector3(0,0,1))
		#$NewWorm.remove_segment($NewWorm.get_tail())
		#const WORM_SCENE = preload("res://scenes/new_worm.tscn")
		#var new_worm = WORM_SCENE.instantiate()
		#new_worm.name = "NewWorm2"
		#add_child(new_worm)
		
		#print(get_children(true))
		#print()
		#print(get_node("NewWorm").get_children(true))
		#print()
		#print(get_node("NewWorm2").get_children(true))
		#$NewWorm.move(Vector3(0,0,1))
		#print($NewWorm/Body/Head.global_position)
		#print($NewWorm/Body/Head.next_pos)
		#print($NewWorm/Body/Head.global_position.distance_to($NewWorm/Body/Head.next_pos))
