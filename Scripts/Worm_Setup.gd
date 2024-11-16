extends Node

var worm_length = 3
const HEAD_AND_TAIL = 2

@onready var body_parts: Node3D = $BodyParts
@onready var worm_body: Path3D = $worm_body
@onready var worm_gfx: CSGPolygon3D = $Worm_GFX
@onready var worm: CharacterBody3D = $Worm

const PART_1 = preload("res://scenes/part1.tscn")
const TAIL_1 = preload("res://scenes/tail1.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	worm.body_parts = body_parts
	worm.worm_body = worm_body
	worm.worm_gfx = worm_gfx
	
	worm_body.curve.clear_points()
	for i in worm_length - HEAD_AND_TAIL:
		var new_part = PART_1.instantiate()
		body_parts.add_child(new_part, true)
		
		var part_number = int(body_parts.get_child(i).name.substr(4, body_parts.get_child(i).name.length() - 4))
		new_part.worm_body = worm_body
		new_part.position = Vector3(0,0,part_number)
	
	var new_tail = TAIL_1.instantiate()
	body_parts.add_child(new_tail, true)
	new_tail.name += str(worm_length - 1)
	new_tail.worm_body = worm_body
	var part_number = int(new_tail.name.substr(4, new_tail.name.length() - 4))
	new_tail.position = Vector3(0,0,part_number)
	
	worm_body.curve.add_point(worm.position)
	for body in body_parts.get_children():
		worm_body.curve.add_point(body.global_position)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
