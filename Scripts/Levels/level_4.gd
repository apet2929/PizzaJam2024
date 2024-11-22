extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("retry"):
		restart_level()

func next_level():
	$SceneTransition.load_out("res://scenes/Menu/Menu.tscn")

func restart_level():
	get_tree().change_scene_to_file(self.scene_file_path)
