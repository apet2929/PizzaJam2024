extends Control

# This node is used to load in particle effect and animations so that 
# when you enter the level it doesn't suck

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_bird_animation_finished(anim_name: StringName) -> void:
	get_tree().change_scene_to_file("res://scenes/Menu/Menu.tscn")
