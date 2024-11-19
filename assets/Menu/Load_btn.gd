extends Node


@export var new_scene = "res://scenes/game.tscn"
@onready var sceneTransition: CanvasLayer = $"../../../SceneTransition"

func _on_pressed() -> void:
	sceneTransition.change_scene(new_scene)
