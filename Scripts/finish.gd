extends Area3D


const WORM_SCRIPT = preload("res://Scripts/new_worm.gd")

func _on_body_entered(body: Node3D) -> void:
	if body.get_script() == WORM_SCRIPT:
		EventBus.level_finished.emit()
