extends Node

@export var scene_path = "res://"
@onready var btn_click: AudioStreamPlayer2D = $"../btn_click"

func _on_pressed() -> void:
	$"../..".change_scene(scene_path)
	btn_click.play()
