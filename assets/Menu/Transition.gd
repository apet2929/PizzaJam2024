extends Node

@onready var anim: AnimationPlayer = $Anim
@export var new_scene = ""
var was_played = false

func _ready() -> void:
	anim.play("RESET")

func _process(_delta: float) -> void:
	# TODO : what is this for?
	if was_played == false:
		anim.play_backwards("load_out")
		was_played = true

func load_in() -> void:
	anim.play_backwards("load_out")
	was_played = false

func load_out(target: String) -> void:
	anim.play("load_out")
	new_scene = target
	was_played = true

func change_scene(target: String):
	anim.play("load_out")
	new_scene = target

func _on_anim_animation_finished(anim_name: StringName) -> void:
	# TODO: this isn't how it should work 
	if anim_name == "load_out":
		get_tree().change_scene_to_file(new_scene)
