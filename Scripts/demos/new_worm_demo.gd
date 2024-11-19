extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_released("ui_accept"):
		$NewWorm.add_segment_to_tail(Vector3(0,0,1))
	if Input.is_action_just_released("ui_text_backspace"):
		$NewWorm.remove_segment($NewWorm.get_tail())
	if Input.is_action_just_released("ui_text_delete"):
		$NewWorm.split()
