extends Node3D

@export var next_lvl = "res://scenes/Levels/Level3.tscn"
const WORM_SCRIPT = preload("res://Scripts/new_worm.gd")
# Contains all the setup/interaction logic specific to this level

func _ready() -> void:
	$SceneTransition.load_in()
	EventBus.connect("level_finished", next_level)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("retry"):
		restart_level()

func next_level():
	$SceneTransition.load_out(next_lvl)

func restart_level():
	get_tree().change_scene_to_file(self.scene_file_path)

func is_worm(body):
	return body.get_script() == WORM_SCRIPT

func _on_pressure_pad_pressed(pressure_pad, _body) -> void:
	if pressure_pad == $PressurePad:
		$Fence.open_fence()

func _on_pressure_pad_unpressed(pressure_pad, _body) -> void:
	if pressure_pad == $PressurePad:
		if $Fence.open:
			$Fence.close_fence()
		
