extends Node3D

signal dropped
@export var dropping = true
@onready var worm: CharacterBody3D = $"../Worm"

func _ready() -> void:
	worm.visible = false
	if dropping:
		start_unpinch()

# Sets up model so it looks like its pinching
func start_unpinch():
	$Model/AnimationPlayer.play_backwards("Pinch")
	$Model/AnimationPlayer.seek(0.833) # end of the pinch animation
	$Model/AnimationPlayer.pause()

func pinch():
	$Model/AnimationPlayer.play("Pinch")
	
func unpinch():
	$Model/AnimationPlayer.play_backwards("Pinch")
	await get_tree().create_timer(0.8).timeout # 0.566 seconds is when the hand looks like it should drop the worm
	dropped.emit()
	pinch()
	worm.visible = true
