extends Node

@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var level_base: Node3D = $".."

func _ready() -> void:
	anim.play("drop")
	await get_tree().create_timer(0.3)
	level_base.drop_worm()
