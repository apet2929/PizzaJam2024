extends Node

@export var scene_path = "res://"
@onready var btn_click: AudioStreamPlayer2D = $"../btn_click"

func _on_pressed() -> void:
	get_tree().change_scene_to_file(scene_path)
	btn_click.play()
