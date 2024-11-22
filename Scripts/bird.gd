extends Node

@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var level_base: Node3D = $".."

func _ready() -> void:
	anim.play("drop")
