extends Node

@export var worm_id = 0
var worm_length = 4
var spawn_points = [Vector3(-0.03, 0.486, 4),Vector3(-1.03, 0.486, 4),Vector3(-2.03, 0.486, 4),Vector3(-3.03, 0.486, 4),Vector3(-4.03, 0.486, 4),Vector3(-5.03, 0.486, 4)]
const HEAD_AND_TAIL = 2

@onready var body_parts: Node3D = $BodyParts
@onready var worm_body: Path3D = $worm_body
@onready var worm_gfx: CSGPolygon3D = $Worm_GFX
@onready var worm: CharacterBody3D = $Body
@onready var camera: Camera3D = $"../Camera3D"

const PART_1 = preload("res://scenes/part1.tscn")
const TAIL_1 = preload("res://scenes/tail1.tscn")
const WORM = preload("res://Scripts/worm_body.gd")
const WORM_SCENE = preload("res://scenes/worm.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	create_worm(spawn_points)

func create_worm(old_points):
	# Setting the worm's head stats
	worm.body_parts = body_parts
	worm_body.curve = Curve3D.new()
	worm.worm_body = worm_body
	worm.worm_gfx = worm_gfx

	camera.worms.append(self.worm)
	add_to_group("worms")

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
	
func _on_button_small_button_pressed(button_id) -> void:
	if button_id == "test":
		# split the worm in half
		pass

func is_worm(body: Node3D) -> bool:
	match body.get_script():
		WORM:
			return true
		_:
			return false

func _on_pressure_pad_body_entered(body: Node3D) -> void:
	print("foo")
	if is_worm(body):
		#$"../Guillotine".drop()
		#await get_tree().create_timer(2).timeout
		#$"../Guillotine".undrop()
		
		var worm1_pts = [self.worm.global_position]
		var worm2_pts = []
		var segments = body_parts.get_children()
		var pts = []
		for i in range(segments.size()):
			pts.append(segments[i].global_position)
			if i < segments.size() / 2:
				worm1_pts.append(segments[i].global_position)
			else:
				worm2_pts.append(segments[i].global_position)
		
		print(pts)
		print(self.worm.global_position)
		print()
		print(worm1_pts)
		print(worm2_pts)
		
		var worms = get_tree().get_nodes_in_group("worms")
		self.queue_free()
		camera.worms.erase(self.worm)
		#print(worm1_pts)
		#print(worm2_pts)
		
		if worm1_pts.size() > 1:
			spawn_worm(worm1_pts)
		#if worm2_pts.size() > 1:
			#spawn_worm(worm2_pts)
		#var new_worm_2 = WORM_SCENE.instantiate()
		#new_worm_2.worm_id = num_worms + 1
		#new_worm_2.worm_length = worm2_pts.size()
		#new_worm_2.spawn_points = worm2_pts
		#get_parent().add_child(new_worm_1)
		
		
func spawn_worm(pts):
	var new_worm = WORM_SCENE.instantiate()
	var num_worms = get_tree().get_nodes_in_group("worms").size()
	new_worm.worm_id = num_worms
	new_worm.get_tree().get("Body").global_position = pts[0]
	new_worm.worm_length = pts.size()
	new_worm.spawn_points = pts
	get_parent().add_child(new_worm)
