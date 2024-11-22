extends Node3D

class_name LevelBase
const WORM_SCRIPT = preload("res://Scripts/new_worm.gd")
# Contains all the setup/interaction logic specific to this level

var dropping = false
var worm_vel_y = 0
const GRAVITY = -9
var worm_initial_y

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	init_signals()
	$SceneTransition.load_in()
	$SceneTransition.anim_done.connect(self.start_level)
	$Hand.dropped.connect(self.drop_worm)
	EventBus.connect("level_finished", next_level)
	worm_initial_y = $Worm.global_position.y
	$Worm.global_position.y = $Hand.global_position.y - 5
	for worm in get_tree().get_nodes_in_group("head"):
		worm.disabled = true
	

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("retry"):
		restart_level()
	if dropping:
		drop_worm_update(delta)
		
func init_signals():
	push_error("Implement me in subclass!")
	#EventBus.connect("button_pressed", self._on_button_pressed)
	#EventBus.connect("button_unpressed", self._on_button_unpressed)
	#EventBus.connect("pressure_pad_pressed", self._on_pressure_pad_pressed)
	#EventBus.connect("pressure_pad_unpressed", self._on_pressure_pad_unpressed)

func next_level():
	push_error("Implement me in subclass!")

func _next_level(next_level):
	EventBus.restart_count = 0
	$SceneTransition.load_out(next_level)

func start_level():
	await get_tree().create_timer(0.3).timeout
	$Hand.unpinch()

func restart_level():
	EventBus.restart_count += 1
	get_tree().change_scene_to_file(self.scene_file_path)

func drop_worm():
	dropping = true
	
func drop_worm_update(delta):
	worm_vel_y += GRAVITY * delta
	$Worm.global_position.y += worm_vel_y * delta
	if abs($Worm.global_position.y - worm_initial_y) < 0.2:
		dropping = false
		$Worm.global_position.y = worm_initial_y
		await get_tree().create_timer(0.1).timeout
		for worm in get_tree().get_nodes_in_group("head"):
			worm.disabled = false

func is_worm(body):
	return body.get_script() == WORM_SCRIPT

func _on_button_small_button_pressed(button_id, body) -> void:
	pass

func _on_button_small_button_unpressed(button_id, body) -> void:
	pass
		
func _on_pressure_pad_pressed(pressure_pad, body) -> void:
	pass

func _on_pressure_pad_unpressed(pressure_pad, body) -> void:
	pass
