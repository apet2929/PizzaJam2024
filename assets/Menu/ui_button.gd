extends Node

@export var scene_path = "res://"

func _on_pressed() -> void:
	$"../..".change_scene(scene_path)
