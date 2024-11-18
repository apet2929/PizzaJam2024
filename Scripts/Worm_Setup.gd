extends Node

var worm_length = 3
const HEAD_AND_TAIL = 2

@onready var body_parts: Node3D = $BodyParts
@onready var worm_body: Path3D = $worm_body
@onready var worm_gfx: CSGPolygon3D = $Worm_GFX
@onready var worm: CharacterBody3D = $Body
@onready var camera: Camera3D = $"../Camera3D"

const PART_1 = preload("res://scenes/part1.tscn")
const TAIL_1 = preload("res://scenes/tail1.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var array = [Vector3(-0.03, 0.486, 4),Vector3(-1.03, 0.486, 4),Vector3(-2.03, 0.486, 4),Vector3(-3.03, 0.486, 4),Vector3(-4.03, 0.486, 4),Vector3(-5.03, 0.486, 4)]
	create_worm(array)

func create_worm(old_points):
	# Setting the worm's head stats
	worm.body_parts = body_parts
	worm_body.curve = Curve3D.new()
	worm.worm_body = worm_body
	worm.worm_gfx = worm_gfx

	camera.worms.append(self.worm)

	# Making the "Worm_GFX" log like
	worm_gfx.polygon = worm.points

	worm_body.curve.clear_points()
	var old_points_used = 0
	
	# Creating all of the worm's middle body part
	for i in worm_length - HEAD_AND_TAIL:
		var new_part = PART_1.instantiate()
		body_parts.add_child(new_part, true)
		
		var part_number = int(body_parts.get_child(i).name.substr(4, body_parts.get_child(i).name.length() - 4))
		new_part.worm_body = worm_body
		
		if i < len(old_points):
			new_part.global_position = old_points[i]
			old_points_used += 1
		else:
			if old_points != []:
				var last_old_point = old_points[max(0,old_points_used - 1)]
				new_part.global_position = Vector3(last_old_point.x,last_old_point.y,last_old_point.z + part_number)
			else:
				new_part.global_position = Vector3(worm.global_position.x,worm.global_position.y,worm.global_position.z + part_number)
		
	# Creating the worm's tail
	
	var new_tail = TAIL_1.instantiate()
	body_parts.add_child(new_tail, true)
	new_tail.name += str(worm_length - 1)
	new_tail.worm_body = worm_body
	var part_number = int(new_tail.name.substr(4, new_tail.name.length() - 4))
	
	if worm_length < len(old_points):
		new_tail.global_position = old_points[old_points_used]
	else:
		if old_points != []:
			var last_old_point = old_points[len(old_points) - 1]
			new_tail.global_position = Vector3(last_old_point.x,last_old_point.y,last_old_point.z + part_number)
		else:
			new_tail.global_position = Vector3(worm.global_position.x,worm.global_position.y,worm.global_position.z + part_number)
	
	# Adding the Worm's body parts to the worm_body 3D Path
	worm_body.curve.add_point(worm.global_position)
	for body in body_parts.get_children():
		worm_body.curve.add_point(body.global_position)

func setup():
	pass
	
func set_length(length):
#	TODO: Implement me!
	pass
	
func _on_button_body_entered(body: Node3D) -> void:
	$"../Guillotine".drop()
	
