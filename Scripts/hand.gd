extends Node3D

signal dropped
@export var dropping = true

func _ready() -> void:
	if dropping:
		start_unpinch()

# Sets up model so it looks like its pinching
func start_unpinch():
	$Model/AnimationPlayer.play_backwards("Pinch")
	$Model/AnimationPlayer.seek(0.833) # end of the pinch animation
	$Model/AnimationPlayer.pause()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func pinch():
	$Model/AnimationPlayer.play("Pinch")
	
func unpinch():
	$Model/AnimationPlayer.play_backwards("Pinch")
	await get_tree().create_timer(0.266).timeout # 0.566 seconds is when the hand looks like it should drop the worm
	dropped.emit()
