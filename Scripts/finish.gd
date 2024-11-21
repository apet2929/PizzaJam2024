extends Area3D


const WORM_SCRIPT = preload("res://Scripts/new_worm.gd")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_body_entered(body: Node3D) -> void:
	if body.get_script() == WORM_SCRIPT:
		EventBus.level_finished.emit()
