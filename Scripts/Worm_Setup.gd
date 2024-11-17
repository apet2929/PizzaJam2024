extends Node

var worm_length = 4
const HEAD_AND_TAIL = 2

@onready var body_parts: Node3D = $BodyParts
@onready var worm: CharacterBody3D = $Worm
@onready var camera: Camera3D = $"../Camera3D"

const PART_2 = preload("res://scenes/part2.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Setting the worm's head stats
	worm.body_parts = body_parts
	
	camera.worms.append(self.worm)
	
	var skeleton = $Worm/Model/Armature/Skeleton3D
	for i in range(0,4):
		print(skeleton.get_bone_pose(i).origin)
	# Creating all of the worm's body part
	
	print("foo: ", Vector3(worm.global_position.x,worm.global_position.y+1,worm.global_position.z+1))
	for i in worm_length:
		var new_part = PART_2.instantiate()
		body_parts.add_child(new_part, true)
		new_part.skeleton = skeleton
		new_part.bone_id = i
		new_part.set_position(Vector3(worm.global_position.x + i,worm.global_position.y,worm.global_position.z))
