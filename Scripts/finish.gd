extends Area3D


const WORM_SCRIPT = preload("res://Scripts/worm.gd")
@onready var win_sfx: AudioStreamPlayer3D = $win_sfx

func _on_body_entered(body: Node3D) -> void:
	if body.get_script() == WORM_SCRIPT:
		print("foo bar")
		EventBus.level_finished.emit(body)
		win_sfx.play()
